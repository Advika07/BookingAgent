require('dotenv').config();
const express = require('express');
const twilio = require('twilio');
const { createClient } = require('@supabase/supabase-js');
const { OpenAI } = require('openai');
const chrono = require('chrono-node');
const app = express();

app.use(express.urlencoded({ extended: false }));
app.use(express.json());

// Initialize Twilio client
if (!process.env.TWILIO_ACCOUNT_SID || !process.env.TWILIO_AUTH_TOKEN) {
  console.error('Twilio credentials missing. Check your .env file.');
  process.exit(1);
}
console.log('Loaded TWILIO_ACCOUNT_SID:', process.env.TWILIO_ACCOUNT_SID);
console.log('Loaded TWILIO_AUTH_TOKEN:', process.env.TWILIO_AUTH_TOKEN);
console.log('Loaded TWILIO_WHATSAPP_NUMBER:', process.env.TWILIO_WHATSAPP_NUMBER);
const twilioClient = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN);

// Initialize Supabase client
if (!process.env.SUPABASE_URL || !process.env.SUPABASE_API_KEY) {
  console.error('Supabase credentials missing. Check your .env file.');
  process.exit(1);
}
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_API_KEY);

// Initialize DeepSeek client (using OpenAI SDK)
if (!process.env.DEEPSEEK_API_KEY) {
  console.error('DeepSeek API key missing. Check your .env file.');
  process.exit(1);
}
const openai = new OpenAI({
  apiKey: process.env.DEEPSEEK_API_KEY,
  baseURL: 'https://api.deepseek.com/v1',
});

// In-memory store to track conversation state
const conversationState = new Map();

// Fetch appointments from Supabase
const fetchAppointments = async () => {
  try {
    const { data, error } = await supabase
      .schema('appointments')
      .from('appointments')
      .select(`
        appt_id,
        store_id,
        assignment_id,
        client_id,
        service_id,
        appt_start,
        appt_end
      `);
    if (error) throw error;
    const appointments = await Promise.all(data.map(async (appt) => {
      const { data: clientData, error: clientError } = await supabase
        .schema('clients')
        .from('clients')
        .select('global_client_id')
        .eq('client_id', appt.client_id)
        .single();
      if (clientError) throw clientError;
      const { data: globalClient, error: globalError } = await supabase
        .schema('clients')
        .from('global_clients')
        .select('client_name, preferred_name, client_ph')
        .eq('global_client_id', clientData.global_client_id)
        .single();
      if (globalError) throw globalError;
      return { ...appt, ...globalClient, phone_number: globalClient.client_ph };
    }));
    return appointments;
  } catch (error) {
    console.error('Error fetching appointments:', error.message);
    throw error;
  }
};

// Fetch store information (updated to include packages)
const fetchStoreInfo = async (storeId) => {
  try {
    const { data: store, error: storeError } = await supabase
      .schema('store_management')
      .from('stores')
      .select('store_id, store_name, store_operating_hours, store_addressL1')
      .eq('store_id', storeId)
      .single();
    if (storeError) throw storeError;

    const { data: services, error: servicesError } = await supabase
      .schema('store_management')
      .from('services')
      .select('service_id, service_name, service_description, price, service_duration')
      .eq('store_id', storeId);
    if (servicesError) throw servicesError;

    const { data: packages, error: packagesError } = await supabase
      .schema('store_management')
      .from('packages')
      .select('package_id, package_name, package_description, package_limit, package_type, num_sessions, num_credits, package_price, services_linked, package_start, package_end')
      .eq('store_id', storeId);
    if (packagesError) throw packagesError;

    return { store, services, packages };
  } catch (error) {
    console.error('Error fetching store info:', error.message);
    throw error;
  }
};

// Create client record
const createClientRecord = async (phoneNumber, name) => {
  try {
    // Insert into global_clients
    const { data: globalClient, error: globalError } = await supabase
      .schema('clients')
      .from('global_clients')
      .insert({
        client_name: name,
        client_ph: parseInt(phoneNumber.slice(3), 10), // Remove +65 and convert to int
      })
      .select('global_client_id')
      .single();
    if (globalError) throw globalError;

    // Insert into clients
    const { data: client, error: clientError } = await supabase
      .schema('clients')
      .from('clients')
      .insert({
        global_client_id: globalClient.global_client_id,
        store_id: null
      })
      .select('client_id')
      .single();
    if (clientError) throw clientError;

    return { clientId: client.client_id, globalClientId: globalClient.global_client_id };
  } catch (error) {
    console.error('Error creating client record:', error.message);
    throw error;
  }
};

// Send appointment reminders (1 day before appt_start)
const sendReminders = async () => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0); // Reset to start of day
    const appointments = await fetchAppointments();
    for (const appt of appointments) {
      const apptStart = new Date(appt.appt_start);
      const diffDays = Math.ceil((apptStart - today) / (1000 * 60 * 60 * 24));
      if (diffDays === 1) { // 1 day before
        try {
          const name = appt.preferred_name || appt.client_name;
          const message = `Hi ${name}, this is a reminder for your ${appt.service_id} appointment at Glamour Salon on ${new Date(appt.appt_start).toLocaleDateString()} at ${new Date(appt.appt_start).toLocaleTimeString()} with your stylist. Reply YES to confirm, NO to cancel, or CHANGE to reschedule.`;
          const result = await twilioClient.messages.create({
            from: process.env.TWILIO_WHATSAPP_NUMBER,
            to: `whatsapp:+65${appt.phone_number}`,
            body: message
          });
          console.log(`Reminder sent to ${name} at ${appt.phone_number}: SID ${result.sid}`);
        } catch (error) {
          console.error(`Failed to send reminder to ${appt.client_name}:`, error.message);
        }
      }
    }
  } catch (error) {
    console.error('Error in sendReminders:', error.message);
    throw error;
  }
};

// Add this before the POST handler
app.get('/twilio-webhook', (req, res) => {
  console.log('Received GET request on /twilio-webhook:', req.query);
  res.status(200).send('Webhook endpoint is active. Use POST for WhatsApp messages.');
});

// Controller for booking appointments
app.post('/book-appointment', async (req, res) => {
  const { client_id, appointment_date, time, service_id, stylist, store_id } = req.body;
  try {
    const apptStart = new Date(appointment_date + 'T' + time + '+08:00');
    const apptEnd = new Date(apptStart.getTime() + 60 * 60 * 1000); // Assuming 1-hour duration for simplicity
    const { data, error } = await supabase
      .schema('appointments')
      .from('appointments')
      .insert({
        store_id,
        assignment_id: null,
        client_id,
        service_id,
        appt_start: apptStart.toISOString(),
        appt_end: apptEnd.toISOString()
      })
      .select();
    if (error) throw error;
    res.status(201).json({ message: 'Appointment booked successfully', appointment: data[0] });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

// Function to rephrase messages using DeepSeek
async function rephraseWithDeepSeek(message, name) {
  try {
    if (!message) {
      return `Hi ${name}! It seems I don’t have enough details to assist you yet. Please let me know what you'd like to do, and I’ll be happy to help!`;
    }

    const prompt = `
      You are a friendly and professional assistant for Glamour Salon. Rephrase the following message to sound warm, natural, and human-like, while addressing the customer by their name (${name}). Keep the tone polite and conversational, as if you're speaking directly to the customer. Do not change the core meaning of the message. Do not include any explanatory notes or brackets.

      Message: "${message}"

      Rephrased message:
    `;

    const completion = await openai.chat.completions.create({
      model: 'deepseek-chat',
      messages: [
        { role: 'system', content: 'You are a helpful assistant for Glamour Salon, specializing in warm and friendly customer communication.' },
        { role: 'user', content: prompt }
      ],
      temperature: 0.7,
      max_tokens: 150,
    });

    return completion.choices[0].message.content.trim();
  } catch (error) {
    console.error('DeepSeek rephrasing error:', error.message);
    return message || `Hi ${name}! I’m having trouble processing your request. Please try again or let me know what you need!`;
  }
}

// Function to parse natural language date and time
function parseDateTime(dateStr, timeStr) {
  const now = new Date();
  let dateTime;

  if (dateStr && timeStr) {
    const fullStr = `${dateStr} ${timeStr}`;
    dateTime = chrono.parseDate(fullStr, now, { forwardDate: true, timezone: 'Asia/Singapore', locale: 'en' });
    if (!dateTime || isNaN(dateTime.getTime())) {
      const today = now.toISOString().split('T')[0];
      dateTime = new Date(`${today}T${timeStr}:00+08:00`);
      if (isNaN(dateTime.getTime()) && dateStr) {
        dateTime = new Date(`${dateStr}T00:00:00+08:00`);
      }
    }
  } else if (dateStr) {
    dateTime = chrono.parseDate(dateStr, now, { forwardDate: true, timezone: 'Asia/Singapore', locale: 'en' });
    if (!dateTime || isNaN(dateTime.getTime())) {
      if (dateStr.toLowerCase().includes('tomorrow')) dateTime = new Date(now.setDate(now.getDate() + 1));
      else if (dateStr.toLowerCase().includes('today')) dateTime = now;
      else dateTime = new Date(dateStr);
    }
    if (dateTime && !isNaN(dateTime.getTime())) {
      dateTime.setHours(0, 0, 0, 0);
    }
  } else if (timeStr) {
    dateTime = new Date(now);
    const timeParts = timeStr.toLowerCase().match(/(\d{1,2})(?::(\d{2}))?\s*(am|pm)?/i);
    if (timeParts) {
      let hours = parseInt(timeParts[1], 10);
      const minutes = timeParts[2] ? parseInt(timeParts[2], 10) : 0;
      const period = timeParts[3]?.toLowerCase();
      if (period === 'pm' && hours < 12) hours += 12;
      else if (period === 'am' && hours === 12) hours = 0;
      dateTime.setHours(hours, minutes, 0, 0);
    }
  }
  if (dateTime && !isNaN(dateTime.getTime())) {
    dateTime.setMinutes(dateTime.getMinutes() + dateTime.getTimezoneOffset() + 480);
    return dateTime;
  }
  return null;
}

// Function to check if the time slot is available and within operating hours
async function checkAvailabilityAndHours(storeId, apptStart, apptEnd, serviceDuration) {
  const MAX_APPOINTMENTS_PER_SLOT = 5;
  const { store } = await fetchStoreInfo(storeId);
  const operatingHours = store.store_operating_hours;
  
  const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  const apptDay = daysOfWeek[apptStart.getDay()];
  const storeHours = operatingHours[apptDay.toLowerCase()];
  
  if (storeHours.isClosed) {
    return {
      isAvailable: false,
      reason: 'closed',
      suggestedTime: suggestNextAvailableTime(storeId, apptStart, serviceDuration, operatingHours)
    };
  }

  const [openHour, openMinute] = storeHours.open.split(':').map(Number);
  const [closeHour, closeMinute] = storeHours.close.split(':').map(Number);
  
  const storeOpenTime = new Date(apptStart);
  storeOpenTime.setHours(openHour, openMinute, 0, 0);
  const storeCloseTime = new Date(apptStart);
  storeCloseTime.setHours(closeHour, closeMinute, 0, 0);

  if (apptStart < storeOpenTime || apptEnd > storeCloseTime) {
    return {
      isAvailable: false,
      reason: 'outside_hours',
      suggestedTime: suggestNextAvailableTime(storeId, apptStart, serviceDuration, operatingHours)
    };
  }

  const { data: existingAppointments, error } = await supabase
    .schema('appointments')
    .from('appointments')
    .select('appt_start, appt_end')
    .eq('store_id', storeId)
    .lte('appt_start', apptEnd.toISOString())
    .gte('appt_end', apptStart.toISOString());
  
  if (error) throw error;

  if (existingAppointments.length >= MAX_APPOINTMENTS_PER_SLOT) {
    return {
      isAvailable: false,
      reason: 'fully_booked',
      suggestedTime: suggestNextAvailableTime(storeId, apptStart, serviceDuration, operatingHours)
    };
  }

  return { isAvailable: true };
}

// Function to suggest the next available time slot
function suggestNextAvailableTime(storeId, requestedTime, serviceDuration, operatingHours) {
  const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  let suggestedTime = new Date(requestedTime);
  let attempts = 0;
  const maxAttempts = 7;

  while (attempts < maxAttempts) {
    const apptDay = daysOfWeek[suggestedTime.getDay()];
    const storeHours = operatingHours[apptDay.toLowerCase()];
    
    if (!storeHours.isClosed) {
      const [openHour, openMinute] = storeHours.open.split(':').map(Number);
      const [closeHour, closeMinute] = storeHours.close.split(':').map(Number);
      
      let nextTime = new Date(suggestedTime);
      nextTime.setHours(openHour, openMinute, 0, 0);
      if (nextTime < suggestedTime) {
        nextTime.setHours(suggestedTime.getHours(), Math.ceil(suggestedTime.getMinutes() / 30) * 30, 0, 0);
      }

      const closeTime = new Date(suggestedTime);
      closeTime.setHours(closeHour, closeMinute, 0, 0);

      while (nextTime < closeTime) {
        const apptEnd = new Date(nextTime.getTime() + serviceDuration * 60 * 1000);
        if (apptEnd <= closeTime) {
          return {
            date: nextTime.toLocaleDateString(),
            time: nextTime.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })
          };
        }
        nextTime.setMinutes(nextTime.getMinutes() + 30);
      }
    }
    
    suggestedTime.setDate(suggestedTime.getDate() + 1);
    suggestedTime.setHours(0, 0, 0, 0);
    attempts++;
  }

  return null;
}

// Function to classify intent and extract details using DeepSeek
async function classifyIntent(message) {
  try {
    const prompt = `
      You are a helpful assistant for Glamour Salon. Analyze the customer's message and classify their intent. The possible intents are:
      - GREETING (e.g., "Hello", "Hi")
      - BOOK_APPOINTMENT (e.g., "I need to book an appointment", "I want a haircut", "I'd like to schedule a service")
      - CHANGE_APPOINTMENT (e.g., "I want to change my booking", "Can I reschedule")
      - STORE_INFO (e.g., "Can I get more details about a salon", "What are your hours", "operating hours for Idle", "address of Glamour Salon", "services at Idle")
      - VIEW_APPOINTMENTS (e.g., "Can I see my upcoming appointments?", "What are my bookings?")
      - CONFIRM_APPOINTMENT (e.g., "YES")
      - CANCEL_APPOINTMENT (e.g., "NO")
      - PACKAGE_INQUIRY (e.g., "Can you tell me about my package?", "Is my package still active?", "How many sessions are left?", "Package details")
      - UNKNOWN (if the intent doesn't match any of the above)

      Additionally, extract any relevant details such as:
      - store_name (e.g., "Idle", "Glamour Salon")
      - service_name (e.g., "haircut", "manicure", or informal terms like "cut" or "nails" that can be mapped to services)
      - date (e.g., "26/05/2025", "tomorrow", "next Friday", "this Friday")
      - time (e.g., "14:00", "2 PM", "12:34 AM", "noon", "10 am")
      - info_type (for STORE_INFO intent: "address" for address-related requests, "hours" for operating hours or schedule requests, "services" for service-related requests)

      Focus on identifying the primary service name even if the message includes extra words (e.g., "Haircut maybe" should be "haircut") or informal terms (e.g., "cut" should be interpreted as "haircut", "nails" as "manicure"). If unsure, prioritize the most likely service based on context.

      Customer message: "${message}"

      Respond in JSON format:
      {
        "intent": "INTENT_NAME",
        "details": {
          "store_name": "STORE_NAME or null",
          "service_name": "SERVICE_NAME or null",
          "date": "DATE or null",
          "time": "TIME or null",
          "info_type": "INFO_TYPE or null"
        }
      }
    `;

    const completion = await openai.chat.completions.create({
      model: 'deepseek-chat',
      messages: [
        { role: 'system', content: 'You are a helpful assistant for Glamour Salon, specializing in understanding customer intents from natural language with a focus on flexible service name and date/time recognition.' },
        { role: 'user', content: prompt }
      ],
      temperature: 0.5,
      max_tokens: 200,
    });

    let responseContent = completion.choices[0].message.content.trim();
    if (responseContent.startsWith('```json')) {
      responseContent = responseContent.replace(/^```json\n/, '').replace(/\n```$/, '');
    }

    return JSON.parse(responseContent);
  } catch (error) {
    console.error('DeepSeek intent classification error:', error.message);
    const lowerMessage = message.toLowerCase();
    if (lowerMessage.includes('book') || lowerMessage.includes('appointment') || lowerMessage.includes('schedule') || lowerMessage.includes('service')) {
      return {
        intent: 'BOOK_APPOINTMENT',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null
        }
      };
    } else if (lowerMessage.includes('change') || lowerMessage.includes('reschedule') || lowerMessage.includes('modify')) {
      return {
        intent: 'CHANGE_APPOINTMENT',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null
        }
      };
    } else if (lowerMessage.includes('details') || lowerMessage.includes('info') || lowerMessage.includes('hours') || lowerMessage.includes('address') || lowerMessage.includes('services')) {
      let infoType = null;
      if (lowerMessage.includes('hours') || lowerMessage.includes('schedule')) infoType = 'hours';
      else if (lowerMessage.includes('address')) infoType = 'address';
      else if (lowerMessage.includes('services')) infoType = 'services';

      return {
        intent: 'STORE_INFO',
        details: {
          store_name: lowerMessage.includes('idle') ? 'Idle' : (lowerMessage.includes('glamour') ? 'Glamour Salon' : null),
          service_name: null,
          date: null,
          time: null,
          info_type: infoType
        }
      };
    } else if (lowerMessage.includes('upcoming') || lowerMessage.includes('appointments') || lowerMessage.includes('bookings')) {
      return {
        intent: 'VIEW_APPOINTMENTS',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null
        }
      };
    } else if (lowerMessage.toUpperCase() === 'YES') {
      return {
        intent: 'CONFIRM_APPOINTMENT',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null
        }
      };
    } else if (lowerMessage.toUpperCase() === 'NO') {
      return {
        intent: 'CANCEL_APPOINTMENT',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null
        }
      };
    } else if (lowerMessage.includes('hello') || lowerMessage.includes('hi')) {
      return {
        intent: 'GREETING',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null
        }
      };
    } else if (lowerMessage.includes('package') || lowerMessage.includes('session') || lowerMessage.includes('credit') || lowerMessage.includes('active')) {
      return {
        intent: 'PACKAGE_INQUIRY',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null
        }
      };
    }

    return {
      intent: 'UNKNOWN',
      details: {
        store_name: null,
        service_name: null,
        date: null,
        time: null,
        info_type: null
      }
    };
  }
}

// Webhook to handle customer replies
app.post('/twilio-webhook', async (req, res) => {
  console.log('Webhook received:', req.body);
  const reply = req.body.Body;
  const from = req.body.From.replace('whatsapp:', '');
  console.log(`Processing message from ${from}: ${reply}`);
  try {
    let fromWithoutPrefix = from;
    if (from.startsWith('+65')) {
      fromWithoutPrefix = from.slice(3);
    }

    let clientData = null;
    let clientLink = null;
    const { data: existingClient, error: clientError } = await supabase
      .schema('clients')
      .from('global_clients')
      .select('client_name, preferred_name, global_client_id, client_ph')
      .eq('client_ph', fromWithoutPrefix)
      .single();
    
    if (!clientError && existingClient) {
      clientData = existingClient;
      const { data: existingClientLink, error: linkError } = await supabase
        .schema('clients')
        .from('clients')
        .select('client_id')
        .eq('global_client_id', clientData.global_client_id)
        .single();
      if (linkError || !existingClientLink) {
        console.error(`No client link found for global_client_id ${clientData.global_client_id}: ${linkError?.message}`);
        res.status(500).send('Error fetching client link.');
        return;
      }
      clientLink = existingClientLink;
    }

    let responseMessage;
    let name = clientData ? (clientData.preferred_name || clientData.client_name || 'there') : 'there';

    const { intent, details } = await classifyIntent(reply);

    if (conversationState.has(from)) {
      const state = conversationState.get(from);
      if (state.step === 'selectOption') {
        const { storeId, storeName } = state;
        const { store, services, packages } = await fetchStoreInfo(storeId);

        if (reply === '1') {
          responseMessage = `Address for ${storeName}: ${store.store_addressL1}`;
        } else if (reply === '2') {
          const hours = store.store_operating_hours;
          const formattedHours = Object.entries(hours)
            .map(([day, info]) => {
              if (info.isClosed) return `${day}: Closed`;
              return `${day}: ${info.open} - ${info.close}`;
            })
            .join('\n');
          responseMessage = `Operating Hours for ${storeName}:\n${formattedHours}`;
        } else if (reply === '3') {
          const serviceList = services.map(s => `${s.service_name}: $${s.price} (${s.service_duration} mins)`).join('\n');
          responseMessage = `Services at ${storeName}:\n${serviceList}`;
        } else if (reply === '4') {
          const packageList = packages.map(p => {
            const startDate = new Date(p.package_start).toLocaleDateString();
            const endDate = new Date(p.package_end).toLocaleDateString();
            return `${p.package_name}: $${p.package_price} (${p.num_sessions} sessions, ${p.num_credits} credits, valid ${startDate} - ${endDate}) - ${p.package_description}`;
          }).join('\n');
          responseMessage = `Packages at ${storeName}:\n${packageList}`;
        } else {
          responseMessage = `Please select an option:\n1. Store Address\n2. Operating Hours\n3. Services\n4. Packages`;
        }
        conversationState.delete(from);
      } else if (state.step === 'book_appointment') {
        if (!state.storeName) {
          if (details.store_name) {
            const { data: storeRecord } = await supabase
              .schema('store_management')
              .from('stores')
              .select('store_id, store_name')
              .eq('store_name', details.store_name)
              .single();
            if (!storeRecord) {
              responseMessage = `Sorry, I couldn't find a store named "${details.store_name}". Could you please try again?`;
            } else {
              state.storeName = storeRecord.store_name;
              state.storeId = storeRecord.store_id;
              state.step = 'book_appointment_service';
              conversationState.set(from, state);
              responseMessage = `Hi ${name}! That's wonderful—I've found your appointment slot at ${state.storeName}. What service would you love to book today? Maybe a fresh haircut, a relaxing manicure, or something else? Let me know, and I’ll get it all set up for you!`;
            }
          } else {
            responseMessage = `Which store would you like to book at (e.g., Idle, Glamour Salon)?`;
          }
        }
      } else if (state.step === 'book_appointment_service') {
        if (!state.serviceName) {
          const { data: services } = await supabase
            .schema('store_management')
            .from('services')
            .select('service_id, service_name, service_duration')
            .eq('store_id', state.storeId);
          let serviceMatch = services.find(s => s.service_name.toLowerCase() === details.service_name?.toLowerCase());
          if (!serviceMatch && details.service_name) {
            const lowerServiceName = details.service_name.toLowerCase();
            const serviceSynonyms = {
              'cut': 'haircut',
              'nails': 'manicure',
              'trim': 'haircut'
            };
            const normalizedService = serviceSynonyms[lowerServiceName] || lowerServiceName;
            serviceMatch = services.find(s => s.service_name.toLowerCase().includes(normalizedService));
          }
          if (serviceMatch) {
            state.serviceName = serviceMatch.service_name;
            state.serviceId = serviceMatch.service_id;
            state.serviceDuration = serviceMatch.service_duration;
            state.step = 'book_appointment_datetime';
            conversationState.set(from, state);
            responseMessage = `Hi ${name}! That’s fantastic—your ${state.serviceName} is available at ${state.storeName}! 🎉 When would you like it? Feel free to say something like 'tomorrow at 2 PM' or 'Friday at noon'—I’ll handle the rest!`;
          } else {
            responseMessage = `Oops, I couldn’t find the service "${details.service_name || reply}" at ${state.storeName}. Did you mean something like 'haircut' or 'manicure'? Feel free to try again or let me know what you had in mind!`;
          }
        }
      } else if (state.step === 'book_appointment_datetime') {
        if (!state.date || !state.time) {
          if (details.date || details.time) {
            const dateTime = parseDateTime(details.date, details.time);
            if (dateTime && !isNaN(dateTime.getTime())) {
              const apptStart = dateTime;
              const apptEnd = new Date(apptStart.getTime() + state.serviceDuration * 60 * 1000);

              const availability = await checkAvailabilityAndHours(state.storeId, apptStart, apptEnd, state.serviceDuration);
              if (!availability.isAvailable) {
                if (availability.reason === 'closed') {
                  responseMessage = `Sorry, ${name}, the store is closed on ${apptStart.toLocaleDateString()}.`;
                } else if (availability.reason === 'outside_hours') {
                  responseMessage = `Sorry, ${name}, the requested time on ${apptStart.toLocaleDateString()} at ${apptStart.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })} is outside our operating hours.`;
                } else if (availability.reason === 'fully_booked') {
                  responseMessage = `Sorry, ${name}, the time slot on ${apptStart.toLocaleDateString()} at ${apptStart.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })} is fully booked.`;
                }
                
                if (availability.suggestedTime) {
                  responseMessage += ` How about ${availability.suggestedTime.date} at ${availability.suggestedTime.time} instead? Or let me know another time that works for you!`;
                } else {
                  responseMessage += ` I couldn’t find an available slot soon. Could you try a different day, or let me know when you’re free?`;
                }
              } else {
                if (!clientData) {
                  state.step = 'collect_client_details';
                  state.from = from;
                  state.appointmentDetails = {
                    storeId: state.storeId,
                    storeName: state.storeName,
                    serviceId: state.serviceId,
                    serviceName: state.serviceName,
                    apptStart: apptStart.toISOString(),
                    apptEnd: apptEnd.toISOString()
                  };
                  conversationState.set(from, state);
                  responseMessage = `To confirm your booking, I’ll need a few details. Could you please share your name and phone number (e.g., John, 96460132)?`;
                } else {
                  const { data, error } = await supabase
                    .schema('appointments')
                    .from('appointments')
                    .insert({
                      store_id: state.storeId,
                      assignment_id: 'b32e113a-0bdc-46ee-95ab-f7260abda24e',
                      client_id: clientLink.client_id,
                      service_id: state.serviceId,
                      appt_start: apptStart.toISOString(),
                      appt_end: apptEnd.toISOString(),
                      prepayment_amt: 50
                    })
                    .select();
                  if (error) throw error;

                  responseMessage = `Great news, ${name}! Your ${state.serviceName} at ${state.storeName} is booked for ${apptStart.toLocaleDateString()} at ${apptStart.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })}. Can’t wait to see you!`;
                  conversationState.delete(from);
                }
              }
            } else {
              responseMessage = `Hmm, I didn’t quite catch that date or time. Could you please try again with something like 'tomorrow at 2 PM' or 'this Friday at 10 am'? I’m here to help!`;
            }
          } else {
            responseMessage = `When would you like your ${state.serviceName} at ${state.storeName}? Feel free to say something like 'tomorrow at 2 PM' or 'this Friday at 10 am'—I’ll handle the rest!`;
          }
        }
      } else if (state.step === 'collect_client_details') {
        const nameMatch = reply.match(/([a-zA-Z\s]+),\s*(\d+)/);
        if (nameMatch) {
          const clientName = nameMatch[1].trim();
          const phoneNumber = nameMatch[2].trim();
          if (phoneNumber !== fromWithoutPrefix) {
            responseMessage = `The phone number you provided (${phoneNumber}) doesn’t match the number you’re messaging from (${fromWithoutPrefix}). Please use the same number or let me know if this is intentional.`;
          } else {
            const { clientId } = await createClientRecord(from, clientName);
            const { data, error } = await supabase
              .schema('appointments')
              .from('appointments')
              .insert({
                store_id: state.appointmentDetails.storeId,
                assignment_id: 'b32e113a-0bdc-46ee-95ab-f7260abda24e',
                client_id: clientId,
                service_id: state.appointmentDetails.serviceId,
                appt_start: state.appointmentDetails.apptStart,
                appt_end: state.appointmentDetails.apptEnd,
                prepayment_amt: 50
              })
              .select();
            if (error) throw error;

            name = clientName;
            responseMessage = `Great news, ${name}! Your ${state.appointmentDetails.serviceName} at ${state.appointmentDetails.storeName} is booked for ${new Date(state.appointmentDetails.apptStart).toLocaleDateString()} at ${new Date(state.appointmentDetails.apptStart).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })}. Can’t wait to see you!`;
            conversationState.delete(from);
          }
        } else {
          responseMessage = `I didn’t quite get that. Please provide your name and phone number in the format: Name, Number (e.g., John, 96460132).`;
        }
      } else if (state.step === 'store_info') {
        if (!state.storeName) {
          if (details.store_name) {
            const { data: storeRecord } = await supabase
              .schema('store_management')
              .from('stores')
              .select('store_id, store_name')
              .eq('store_name', details.store_name)
              .single();
            if (!storeRecord) {
              responseMessage = `Sorry, I couldn't find a store named "${details.store_name}". Could you please try again?`;
            } else {
              state.storeName = storeRecord.store_name;
              state.storeId = storeRecord.store_id;
              state.step = 'selectOption';
              conversationState.set(from, state);
              responseMessage = `I found ${state.storeName}! What would you like to know about it?\n1. Store Address\n2. Operating Hours\n3. Services\n4. Packages`;
            }
          } else {
            responseMessage = `Which store would you like more details about (e.g., Idle, Glamour Salon)?`;
          }
        }
      } else if (state.step === 'view_appointments') {
        const nameMatch = reply.match(/([a-zA-Z\s]+),\s*(\d+)/);
        if (nameMatch) {
          const clientName = nameMatch[1].trim();
          const phoneNumber = nameMatch[2].trim();
          if (phoneNumber !== fromWithoutPrefix) {
            responseMessage = `The phone number you provided (${phoneNumber}) doesn’t match the number you’re messaging from (${fromWithoutPrefix}). Please use the same number or let me know if this is intentional.`;
          } else {
            const { clientId } = await createClientRecord(from, clientName);
            const { data: appointments, error: apptError } = await supabase
              .schema('appointments')
              .from('appointments')
              .select('appt_id, appt_start, service_id, store_id')
              .eq('client_id', clientId);
            if (apptError) throw apptError;

            name = clientName;
            if (!appointments || appointments.length === 0) {
              responseMessage = `Hi ${name}, it looks like you don’t have any upcoming appointments. Would you like to book one now?`;
            } else {
              const apptDetails = await Promise.all(appointments.map(async (appt) => {
                const { data: store } = await supabase
                  .schema('store_management')
                  .from('stores')
                  .select('store_name')
                  .eq('store_id', appt.store_id)
                  .single();
                return `${appt.service_id} at ${store.store_name} on ${new Date(appt.appt_start).toLocaleDateString()} at ${new Date(appt.appt_start).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })}`;
              }));
              responseMessage = `Hi ${name}, here are your upcoming appointments:\n${apptDetails.join('\n')}`;
            }
            conversationState.delete(from);
          }
        } else {
          responseMessage = `I didn’t quite get that. Please provide your name and phone number in the format: Name, Number (e.g., John, 96460132).`;
        }
      } else if (state.step === 'change_appointment') {
        const { data: apptData, error: apptError } = await supabase
          .schema('appointments')
          .from('appointments')
          .select('appt_id, appt_start, appt_end, service_id')
          .eq('client_id', clientLink.client_id)
          .order('appt_start', { ascending: false })
          .limit(1)
          .single();
        if (apptError || !apptData) {
          responseMessage = `No appointment found to change for ${name}. Would you like to book a new appointment instead?`;
          conversationState.delete(from);
        } else {
          if (details.date || details.time) {
            const dateTime = parseDateTime(details.date, details.time);
            if (dateTime && !isNaN(dateTime.getTime())) {
              const apptStart = dateTime;
              const apptEnd = new Date(apptStart.getTime() + (apptData.appt_end - apptData.appt_start));
              await supabase
                .schema('appointments')
                .from('appointments')
                .update({ appt_start: apptStart.toISOString(), appt_end: apptEnd.toISOString() })
                .eq('appt_id', apptData.appt_id);
              responseMessage = `All set, ${name}! Your ${apptData.service_id} appointment is now rescheduled to ${apptStart.toLocaleDateString()} at ${apptStart.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })}.`;
              conversationState.delete(from);
            } else {
              responseMessage = `I didn’t quite get that date or time. Please try again with something like 'tomorrow at 2 PM' or 'this Friday at 10 am'.`;
            }
          } else {
            responseMessage = `When would you like to reschedule your ${apptData.service_id} appointment? Just let me know with something like 'tomorrow at 2 PM' or 'this Friday at 10 am'!`;
          }
        }
      } else if (state.step === 'package_inquiry') {
        if (!state.phoneNumberRequested) {
          state.phoneNumberRequested = true;
          conversationState.set(from, state);
          responseMessage = `I'd love to help you with your package details, ${name}! Could you please provide your registered phone number (e.g., 96460132) so I can look it up for you?`;
        } else {
          const phoneNumber = reply;
          const { data: globalClient, error: globalError } = await supabase
            .schema('clients')
            .from('global_clients')
            .select('global_client_id')
            .eq('client_ph', phoneNumber)
            .single();
          if (globalError || !globalClient) {
            responseMessage = `Sorry, ${name}, I couldn’t find a client with the phone number ${phoneNumber}. Please try again with your registered number or contact support.`;
            conversationState.delete(from);
          } else {
            const { data: clientPackages, error: packageError } = await supabase
              .schema('clients')
              .from('client_packages')
              .select(`
                client_package_id,
                store_id,
                package_id,
                global_client_id,
                client_id,
                session_remaining,
                credits_remaining,
                purchase_date,
                status
              `)
              .eq('global_client_id', globalClient.global_client_id);
            if (packageError || !clientPackages || clientPackages.length === 0) {
              responseMessage = `It looks like you don’t have any active packages, ${name}. Would you like to purchase one?`;
              conversationState.delete(from);
            } else {
              const packageDetails = await Promise.all(clientPackages.map(async (pkg) => {
                const { data: store, error: storeError } = await supabase
                  .schema('store_management')
                  .from('stores')
                  .select('store_name')
                  .eq('store_id', pkg.store_id)
                  .single();
                if (storeError) throw storeError;

                const { data: packageInfo, error: packageInfoError } = await supabase
                  .schema('store_management')
                  .from('packages')
                  .select(`
                    package_name,
                    package_description,
                    num_sessions,
                    num_credits,
                    package_price,
                    package_start,
                    package_end
                  `)
                  .eq('package_id', pkg.package_id)
                  .single();
                if (packageInfoError) throw packageInfoError;

                const purchaseDate = new Date(pkg.purchase_date).toLocaleDateString();
                const packageStart = new Date(packageInfo.package_start).toLocaleDateString();
                const packageEnd = new Date(packageInfo.package_end).toLocaleDateString();

                return `Package: ${packageInfo.package_name} at ${store.store_name}\n` +
                       `Description: ${packageInfo.package_description}\n` +
                       `Price: $${packageInfo.package_price}\n` +
                       `Total Sessions: ${packageInfo.num_sessions}, Sessions Remaining: ${pkg.session_remaining}\n` +
                       `Total Credits: ${packageInfo.num_credits}, Credits Remaining: ${pkg.credits_remaining}\n` +
                       `Purchased On: ${purchaseDate}\n` +
                       `Valid From: ${packageStart} to ${packageEnd}\n` +
                       `Status: ${pkg.status}`;
              }));
              responseMessage = `Here are your package details, ${name}:\n${packageDetails.join('\n\n')}\nLet me know if you need more information!`;
              conversationState.delete(from);
            }
          }
        }
      }
    } else {
      if (intent === 'GREETING') {
        responseMessage = `Hi ${name}, how can I help you today? You can:\n- Book an appointment (e.g., "I need to book an appointment")\n- Get store info (e.g., "Can I get more details about a salon")\n- See your upcoming appointments (e.g., "Can I see my upcoming appointments?")\nWhat would you like to do?`;
      } else if (intent === 'BOOK_APPOINTMENT') {
        if (!clientData) {
          conversationState.set(from, { step: 'collect_client_details', from, intent: 'BOOK_APPOINTMENT' });
          responseMessage = `To book an appointment, I’ll need a few details. Could you please share your name and phone number (e.g., John, 96460132)?`;
        } else {
          conversationState.set(from, { step: 'book_appointment' });
          responseMessage = `I'd be happy to help you book an appointment, ${name}! Which store would you like to book at (e.g., Idle, Glamour Salon)?`;
        }
      } else if (intent === 'VIEW_APPOINTMENTS') {
        if (!clientData) {
          conversationState.set(from, { step: 'view_appointments', from });
          responseMessage = `To view your appointments, I’ll need a few details. Could you please share your name and phone number (e.g., John, 96460132)?`;
        } else {
          const { data: appointments, error: apptError } = await supabase
            .schema('appointments')
            .from('appointments')
            .select('appt_id, appt_start, service_id, store_id')
            .eq('client_id', clientLink.client_id);
          if (apptError) throw apptError;

          if (!appointments || appointments.length === 0) {
            responseMessage = `Hi ${name}, it looks like you don’t have any upcoming appointments. Would you like to book one now?`;
          } else {
            const apptDetails = await Promise.all(appointments.map(async (appt) => {
              const { data: store } = await supabase
                .schema('store_management')
                .from('stores')
                .select('store_name')
                .eq('store_id', appt.store_id)
                .single();
              return `${appt.service_id} at ${store.store_name} on ${new Date(appt.appt_start).toLocaleDateString()} at ${new Date(appt.appt_start).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })}`;
            }));
            responseMessage = `Hi ${name}, here are your upcoming appointments:\n${apptDetails.join('\n')}`;
          }
        }
      } else if (intent === 'CHANGE_APPOINTMENT') {
        if (!clientData) {
          conversationState.set(from, { step: 'collect_client_details', from, intent: 'CHANGE_APPOINTMENT' });
          responseMessage = `To change your appointment, I’ll need a few details. Could you please share your name and phone number (e.g., John, 96460132)?`;
        } else {
          const { data: apptData, error: apptError } = await supabase
            .schema('appointments')
            .from('appointments')
            .select('appt_id, appt_start, service_id')
            .eq('client_id', clientLink.client_id)
            .order('appt_start', { ascending: false })
            .limit(1)
            .single();
          if (apptError || !apptData) {
            responseMessage = `No appointment found to change for ${name}. Would you like to book a new appointment instead?`;
          } else {
            conversationState.set(from, { step: 'change_appointment' });
            responseMessage = `Let's reschedule your ${apptData.service_id} appointment, ${name}. When would you like it? Try something like 'tomorrow at 2 PM' or 'this Friday at 10 am'!`;
          }
        }
      } else if (intent === 'STORE_INFO') {
        conversationState.set(from, { step: 'store_info' });
        responseMessage = `I'd be happy to help with that, ${name}! Which store would you like more details about (e.g., Idle, Glamour Salon)?`;
      } else if (intent === 'CONFIRM_APPOINTMENT') {
        if (!clientData) {
          conversationState.set(from, { step: 'collect_client_details', from, intent: 'CONFIRM_APPOINTMENT' });
          responseMessage = `To confirm your appointment, I’ll need a few details. Could you please share your name and phone number (e.g., John, 96460132)?`;
        } else {
          const { data: apptData, error: apptError } = await supabase
            .schema('appointments')
            .from('appointments')
            .select('appt_id, appt_start, service_id')
            .eq('client_id', clientLink.client_id)
            .order('appt_start', { ascending: false })
            .limit(1)
            .single();
          if (apptError || !apptData) {
            responseMessage = `No appointment found to confirm for ${name}. Would you like to book a new appointment?`;
          } else {
            await supabase
              .schema('appointments')
              .from('appointments')
              .update({ status: 'confirmed' })
              .eq('appt_id', apptData.appt_id);
            responseMessage = `Thank you, ${name}! Your ${apptData.service_id} appointment on ${new Date(apptData.appt_start).toLocaleDateString()} at ${new Date(apptData.appt_start).toLocaleTimeString()} is confirmed.`;
          }
        }
      } else if (intent === 'CANCEL_APPOINTMENT') {
        if (!clientData) {
          conversationState.set(from, { step: 'collect_client_details', from, intent: 'CANCEL_APPOINTMENT' });
          responseMessage = `To cancel your appointment, I’ll need a few details. Could you please share your name and phone number (e.g., John, 96460132)?`;
        } else {
          const { data: apptData, error: apptError } = await supabase
            .schema('appointments')
            .from('appointments')
            .select('appt_id, appt_start, service_id')
            .eq('client_id', clientLink.client_id)
            .order('appt_start', { ascending: false })
            .limit(1)
            .single();
          if (apptError || !apptData) {
            responseMessage = `No appointment found to cancel for ${name}. Would you like to book a new appointment?`;
          } else {
            await supabase
              .schema('appointments')
              .from('appointments')
              .delete()
              .eq('appt_id', apptData.appt_id);
            responseMessage = `Sorry to hear that, ${name}. Your ${apptData.service_id} appointment on ${new Date(apptData.appt_start).toLocaleDateString()} at ${new Date(apptData.appt_start).toLocaleTimeString()} has been canceled.`;
          }
        }
      } else if (intent === 'PACKAGE_INQUIRY') {
        conversationState.set(from, { step: 'package_inquiry', phoneNumberRequested: false });
        responseMessage = `I'd love to help you with your package details, ${name}! Could you please provide your registered phone number (e.g., 96460132) so I can look it up for you?`;
      } else {
        const lowerMessage = reply.toLowerCase();
        if (lowerMessage.includes('book') || lowerMessage.includes('appointment') || lowerMessage.includes('schedule') || lowerMessage.includes('service')) {
          if (!clientData) {
            conversationState.set(from, { step: 'collect_client_details', from, intent: 'BOOK_APPOINTMENT' });
            responseMessage = `To book an appointment, I’ll need a few details. Could you please share your name and phone number (e.g., John, 96460132)?`;
          } else {
            conversationState.set(from, { step: 'book_appointment' });
            responseMessage = `I'd be happy to help you book an appointment, ${name}! Which store would you like to book at (e.g., Idle, Glamour Salon)?`;
          }
        } else {
          responseMessage = `Hi ${name}, how can I help you today? You can:\n- Book an appointment (e.g., "I need to book an appointment")\n- Get store info (e.g., "Can I get more details about a salon")\n- See your upcoming appointments (e.g., "Can I see my upcoming appointments?")\nWhat would you like to do?`;
        }
      }
    }

    const rephrasedMessage = await rephraseWithDeepSeek(responseMessage, name);

    const result = await twilioClient.messages.create({
      from: process.env.TWILIO_WHATSAPP_NUMBER,
      to: `whatsapp:${from}`,
      body: rephrasedMessage
    });
    console.log(`Reply from ${name} (${from}): ${reply}`);
    console.log(`Response sent: ${rephrasedMessage}, SID: ${result.sid}`);
    res.status(200).send('Reply processed.');
  } catch (error) {
    console.error(`Failed to process webhook for ${from}:`, error.message);
    res.status(500).send('Error processing reply.');
  }
});

// Start the server and send reminders
const port = process.env.PORT || 3001;
app.listen(port, async () => {
  console.log(`Server running on port ${port}`);
  try {
    await sendReminders();
  } catch (error) {
    console.error('Error during reminder sending:', error.message);
  }
});

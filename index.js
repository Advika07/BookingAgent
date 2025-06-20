require('dotenv').config()
const express = require('express')
const twilio = require('twilio')
const { createClient } = require('@supabase/supabase-js')
const { OpenAI } = require('openai')
const chrono = require('chrono-node')
const app = express()

app.use(express.urlencoded({ extended: false }))
app.use(express.json())

console.log('Starting application setup...')

// Verify environment variables and initialize clients
if (!process.env.TWILIO_ACCOUNT_SID || !process.env.TWILIO_AUTH_TOKEN) {
  console.error('Twilio credentials missing check your .env file')
  process.exit(1)
}
console.log('Twilio credentials loaded successfully')
console.log('Loaded TWILIO_ACCOUNT_SID:', process.env.TWILIO_ACCOUNT_SID)
console.log('Loaded TWILIO_AUTH_TOKEN:', process.env.TWILIO_AUTH_TOKEN)
console.log('Loaded TWILIO_WHATSAPP_NUMBER:', process.env.TWILIO_WHATSAPP_NUMBER)
const twilioClient = twilio(process.env.TWILIO_ACCOUNT_SID, process.env.TWILIO_AUTH_TOKEN)
console.log('Twilio client initialized')

if (!process.env.SUPABASE_URL || !process.env.SUPABASE_API_KEY) {
  console.error('Supabase credentials missing check your .env file')
  process.exit(1)
}
console.log('Supabase credentials loaded successfully')
const supabase = createClient(process.env.SUPABASE_URL, process.env.SUPABASE_API_KEY)
console.log('Supabase client initialized')

if (!process.env.DEEPSEEK_API_KEY) {
  console.error('DeepSeek API key missing check your .env file')
  process.exit(1)
}
console.log('DeepSeek API key loaded successfully')
const openai = new OpenAI({
  apiKey: process.env.DEEPSEEK_API_KEY,
  baseURL: 'https://api.deepseek.com/v1',
})
console.log('OpenAI client initialized')

const conversationState = new Map()
console.log('Conversation state map initialized')

const fetchAppointments = async () => {
  try {
    console.log('Fetching appointments...')
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
      `)
    if (error) throw error
    console.log('Appointments fetched:', data.length)
    const appointments = await Promise.all(data.map(async (appt) => {
      const { data: clientData, error: clientError } = await supabase
        .schema('clients')
        .from('clients')
        .select('global_client_id')
        .eq('client_id', appt.client_id)
        .single()
      if (clientError) throw clientError
      const { data: globalClient, error: globalError } = await supabase
        .schema('clients')
        .from('global_clients')
        .select('client_name, preferred_name, client_ph')
        .eq('global_client_id', clientData.global_client_id)
        .single()
      if (globalError) throw globalError
      return { ...appt, ...globalClient, phone_number: globalClient.client_ph }
    }))
    return appointments
  } catch (error) {
    console.error('Error fetching appointments:', error.message)
    throw error
  }
}

const fetchStoreInfo = async (storeId) => {
  try {
    console.log('Fetching store info for storeId:', storeId)
    const { data: store, error: storeError } = await supabase
      .schema('store_management')
      .from('stores')
      .select('store_id, store_name, store_operating_hours, store_addressL1')
      .eq('store_id', storeId)
      .single()
    if (storeError) throw storeError
    console.log('Store fetched:', store)

    const { data: services, error: servicesError } = await supabase
      .schema('store_management')
      .from('services')
      .select('service_id, service_name, service_description, price, service_duration')
      .eq('store_id', storeId)
    if (servicesError) throw servicesError
    console.log('Services fetched:', services.length)

    const { data: packages, error: packagesError } = await supabase
      .schema('store_management')
      .from('packages')
      .select('package_id, package_name, package_description, package_limit, package_type, num_sessions, num_credits, package_price, services_linked, package_start, package_end')
      .eq('store_id', storeId)
    if (packagesError) throw packagesError
    console.log('Packages fetched:', packages.length)

    return { store, services, packages }
  } catch (error) {
    console.error('Error fetching store info:', error.message)
    throw error
  }
}

const createClientRecord = async (phoneNumber, name) => {
  try {
    console.log('Creating client record for phone:', phoneNumber)
    const { data: globalClient, error: globalError } = await supabase
      .schema('clients')
      .from('global_clients')
      .insert({
        client_name: name,
        client_ph: parseInt(phoneNumber.slice(3), 10),
      })
      .select('global_client_id')
      .single()
    if (globalError) throw globalError

    const { data: client, error: clientError } = await supabase
      .schema('clients')
      .from('clients')
      .insert({
        global_client_id: globalClient.global_client_id,
        store_id: 'b32e113a-0bdc-46ee-95ab-f7260abda24e' // Hardcoded store_id
      })
      .select('client_id')
      .single()
    if (clientError) throw clientError

    return { clientId: client.client_id, globalClientId: globalClient.global_client_id }
  } catch (error) {
    console.error('Error creating client record:', error.message)
    throw error
  }
}

const linkClientToStore = async (globalClientId, storeId) => {
  try {
    console.log('Linking client to store:', globalClientId, storeId)
    const { error } = await supabase
      .schema('clients')
      .from('clients')
      .update({ store_id: storeId })
      .eq('global_client_id', globalClientId)
    if (error) throw error
  } catch (error) {
    console.error('Error linking client to store:', error.message)
    throw error
  }
}

const sendReminders = async () => {
  try {
    console.log('Sending reminders...')
    const today = new Date()
    today.setHours(0, 0, 0, 0)
    const appointments = await fetchAppointments()
    for (const appt of appointments) {
      const apptStart = new Date(appt.appt_start)
      const diffDays = Math.ceil((apptStart - today) / (1000 * 60 * 60 * 24))
      if (diffDays === 1) {
        try {
          const name = appt.preferred_name || appt.client_name
          const message = `hi ${name} this is a reminder for your ${appt.service_id} appointment at Glamour Salon on ${new Date(appt.appt_start).toLocaleDateString()} at ${new Date(appt.appt_start).toLocaleTimeString()} with your stylist reply YES to confirm NO to cancel or CHANGE to reschedule`
          const result = await twilioClient.messages.create({
            from: process.env.TWILIO_WHATSAPP_NUMBER,
            to: `whatsapp:+65${appt.phone_number}`,
            body: message
          })
          console.log(`Reminder sent to ${name} at ${appt.phone_number}: SID ${result.sid}`)
        } catch (error) {
          console.error(`Failed to send reminder to ${appt.client_name}: ${error.message}`)
        }
      }
    }
  } catch (error) {
    console.error('Error in sendReminders:', error.message)
    throw error
  }
}

app.get('/twilio-webhook', (req, res) => {
  console.log('Received GET request on /twilio-webhook:', req.query)
  res.status(200).send('Webhook endpoint is active use POST for WhatsApp messages')
})

app.post('/book-appointment', async (req, res) => {
  console.log('Received book-appointment request:', req.body)
  const { client_id, appointment_date, time, service_id, stylist, store_id } = req.body
  try {
    const apptStart = new Date(appointment_date + 'T' + time + '+08:00')
    const apptEnd = new Date(apptStart.getTime() + 60 * 60 * 1000)
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
      .select()
    if (error) throw error
    res.status(201).json({ message: 'Appointment booked successfully', appointment: data[0] })
  } catch (error) {
    res.status(400).json({ error: error.message })
  }
})

async function rephraseWithDeepSeek(message, name, storeName = null) {
  try {
    console.log('Rephrasing message:', message)
    if (!message) {
      return `hi ${name} I don't have enough details yet please let me know what you'd like to do and I'll help you`
    }

    let prompt = `
      You are a friendly and professional assistant for Glamour Salon rephrase the following message to sound warm natural and human-like while addressing the customer by their name (${name}) keep the tone polite and conversational as if you're speaking directly to the customer do not change the core meaning of the message do not include any explanatory notes brackets emojis or unnecessary punctuation
    `

    if (storeName) {
      prompt += `
      The message may reference a store. Ensure that any reference to a store uses the name "${storeName}" instead of any other store name like "Glamour Salon" unless explicitly intended.
      `
    }

    prompt += `
      Message: "${message}"

      Rephrased message:
    `

    const completion = await openai.chat.completions.create({
      model: 'deepseek-chat',
      messages: [
        { role: 'system', content: 'You are a helpful assistant for Glamour Salon specializing in warm and friendly customer communication' },
        { role: 'user', content: prompt }
      ],
      temperature: 0.7,
      max_tokens: 150,
    })

    let rephrased = completion.choices[0].message.content.trim()
    rephrased = rephrased.replace(/\[Name\]/g, name)
    return rephrased
  } catch (error) {
    console.error('DeepSeek rephrasing error:', error.message)
    return message || `hi ${name} I'm having trouble with your request please try again or let me know what you need`
  }
}

function parseDateTime(dateStr, timeStr) {
  const now = new Date()
  let dateTime

  if (dateStr && timeStr) {
    const fullStr = `${dateStr} ${timeStr}`
    dateTime = chrono.parseDate(fullStr, now, { forwardDate: true, timezone: 'Asia/Singapore', locale: 'en' })
    if (!dateTime || isNaN(dateTime.getTime())) {
      const today = now.toISOString().split('T')[0]
      dateTime = new Date(`${today}T${timeStr}:00+08:00`)
      if (isNaN(dateTime.getTime()) && dateStr) {
        dateTime = new Date(`${dateStr}T00:00:00+08:00`)
      }
    }
  } else if (dateStr) {
    dateTime = chrono.parseDate(dateStr, now, { forwardDate: true, timezone: 'Asia/Singapore', locale: 'en' })
    if (!dateTime || isNaN(dateTime.getTime())) {
      if (dateStr.toLowerCase().includes('tomorrow')) dateTime = new Date(now.setDate(now.getDate() + 1))
      else if (dateStr.toLowerCase().includes('today')) dateTime = now
      else dateTime = new Date(dateStr)
    }
    if (dateTime && !isNaN(dateTime.getTime())) {
      dateTime.setHours(0, 0, 0, 0)
    }
  } else if (timeStr) {
    dateTime = new Date(now)
    const timeParts = timeStr.toLowerCase().match(/(\d{1,2})(?::(\d{2}))?\s*(am|pm)?/i)
    if (timeParts) {
      let hours = parseInt(timeParts[1], 10)
      const minutes = timeParts[2] ? parseInt(timeParts[2], 10) : 0
      const period = timeParts[3]?.toLowerCase()
      if (period === 'pm' && hours < 12) hours += 12
      else if (period === 'am' && hours === 12) hours = 0
      dateTime.setHours(hours, minutes, 0, 0)
    }
  }
  if (dateTime && !isNaN(dateTime.getTime())) {
    return dateTime
  }
  return null
}

async function checkAvailabilityAndHours(storeId, apptStart, apptEnd, serviceDuration) {
  const MAX_APPOINTMENTS_PER_SLOT = 5
  const { store } = await fetchStoreInfo(storeId)
  const operatingHours = store.store_operating_hours
  
  const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  const apptDay = daysOfWeek[apptStart.getDay()]
  const storeHours = operatingHours[apptDay]
  
  if (!storeHours) {
    throw new Error(`Operating hours for ${apptDay} not found for store ${storeId}`)
  }

  if (storeHours.isClosed) {
    return {
      isAvailable: false,
      reason: 'closed',
      suggestedTime: suggestNextAvailableTime(storeId, apptStart, serviceDuration, operatingHours)
    }
  }

  const [openHour, openMinute] = storeHours.open.split(':').map(Number)
  const [closeHour, closeMinute] = storeHours.close.split(':').map(Number)
  
  const storeOpenTime = new Date(apptStart)
  storeOpenTime.setHours(openHour, openMinute, 0, 0)
  const storeCloseTime = new Date(apptStart)
  storeCloseTime.setHours(closeHour, closeMinute, 0, 0)

  if (apptStart < storeOpenTime || apptEnd > storeCloseTime) {
    return {
      isAvailable: false,
      reason: 'outside_hours',
      suggestedTime: suggestNextAvailableTime(storeId, apptStart, serviceDuration, operatingHours)
    }
  }

  const { data: existingAppointments, error } = await supabase
    .schema('appointments')
    .from('appointments')
    .select('appt_start, appt_end')
    .eq('store_id', storeId)
    .lte('appt_start', apptEnd.toISOString())
    .gte('appt_end', apptStart.toISOString())
  
  if (error) throw error

  if (existingAppointments.length >= MAX_APPOINTMENTS_PER_SLOT) {
    return {
      isAvailable: false,
      reason: 'fully_booked',
      suggestedTime: suggestNextAvailableTime(storeId, apptStart, serviceDuration, operatingHours)
    }
  }

  return { isAvailable: true }
}

function suggestNextAvailableTime(storeId, requestedTime, serviceDuration, operatingHours) {
  const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
  let suggestedTime = new Date(requestedTime)
  let attempts = 0
  const maxAttempts = 7

  while (attempts < maxAttempts) {
    const apptDay = daysOfWeek[suggestedTime.getDay()]
    const storeHours = operatingHours[apptDay]
    
    if (!storeHours) {
      suggestedTime.setDate(suggestedTime.getDate() + 1)
      suggestedTime.setHours(0, 0, 0, 0)
      attempts++
      continue
    }

    if (!storeHours.isClosed) {
      const [openHour, openMinute] = storeHours.open.split(':').map(Number)
      const [closeHour, closeMinute] = storeHours.close.split(':').map(Number)
      
      let nextTime = new Date(suggestedTime)
      nextTime.setHours(openHour, openMinute, 0, 0)
      if (nextTime < suggestedTime) {
        nextTime.setHours(suggestedTime.getHours(), Math.ceil(suggestedTime.getMinutes() / 30) * 30, 0, 0)
      }

      const closeTime = new Date(suggestedTime)
      closeTime.setHours(closeHour, closeMinute, 0, 0)

      while (nextTime < closeTime) {
        const apptEnd = new Date(nextTime.getTime() + serviceDuration * 60 * 1000)
        if (apptEnd <= closeTime) {
          return {
            date: nextTime.toLocaleDateString(),
            time: nextTime.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })
          }
        }
        nextTime.setMinutes(nextTime.getMinutes() + 30)
      }
    }
    
    suggestedTime.setDate(suggestedTime.getDate() + 1)
    suggestedTime.setHours(0, 0, 0, 0)
    attempts++
  }

  return null
}

async function classifyIntent(message, currentState = {}) {
  try {
    console.log('Classifying intent for message:', message, 'with current state:', currentState)
    const prompt = `
      You are a helpful assistant for Glamour Salon. Analyze the customer's message and classify their intent, considering the current conversation state: ${JSON.stringify(currentState)}. The possible intents are:
      - GREETING (e.g., "hello", "hi", "hey there", "good morning")
      - BOOK_APPOINTMENT (e.g., "i need to book an appointment", "i want a haircut", "i'd like to schedule a service", "can i book a manicure", "book me for a trim")
      - CHANGE_APPOINTMENT (e.g., "i want to change my booking", "can i reschedule", "move my appointment", "change my time slot")
      - STORE_INFO (e.g., "can i get more details about a salon", "what are your hours", "operating hours for Idle", "address of Glamour Salon", "services at Idle", "what do you offer", "can u get store details for me")
      - VIEW_APPOINTMENTS (e.g., "can i see my upcoming appointments", "what are my bookings", "show my appointments", "what's my schedule", "do i have any appointments", "i want to see upcoming appointments")
      - CONFIRM_APPOINTMENT (e.g., "YES", "yes", "confirm", "i confirm")
      - CANCEL_APPOINTMENT (e.g., "NO", "no", "cancel", "i want to cancel")
      - PACKAGE_INQUIRY (e.g., "can you tell me about my package", "is my package still active", "how many sessions are left", "package details", "what's my package status")
      - PROVIDE_PHONE_NUMBER (e.g., "96460132", "6596460132" when the state step is 'package_inquiry' and phoneNumberRequested is true)
      - REGISTER_CONFIRM (e.g., "YES", "yes", "sure", "okay" for confirming registration)
      - REGISTER_DECLINE (e.g., "NO", "no", "not now" for declining registration)
      - UNKNOWN (if the intent doesn't match any of the above)

      **Contextual Rules**:
      - If the current state has step 'book_appointment' and the message is a store name (e.g., "Idle", "Glamour Salon"), classify the intent as BOOK_APPOINTMENT and extract the store_name.
      - If the current state has step 'store_info' and the message is a store name (e.g., "Idle", "Glamour Salon"), classify the intent as STORE_INFO and extract the store_name.
      - If the current state has step 'book_appointment_service' and the message contains a service name (e.g., "haircut", "manicure"), classify the intent as BOOK_APPOINTMENT and extract the service_name.
      - If the current state has step 'book_appointment_datetime' and the message contains a date or time (e.g., "tomorrow at 2 PM"), classify the intent as BOOK_APPOINTMENT and extract the date and time.
      - If the current state has step 'selectOption' and the message contains keywords like "address", "hours", "services", or "packages", classify the intent as STORE_INFO and set the info_type accordingly.
      - If the current state has step 'package_inquiry' and phoneNumberRequested is true, and the message is a sequence of digits (e.g., "96460132", "6596460132"), classify the intent as PROVIDE_PHONE_NUMBER and extract the phone_number.

      Additionally extract any relevant details such as:
      - store_name (e.g., "Idle", "Glamour Salon", "Idle salon")
      - service_name (e.g., "haircut", "manicure" or informal terms like "cut" or "nails" that can be mapped to services)
      - date (e.g., "26/05/2025", "tomorrow", "next Friday", "this Friday")
      - time (e.g., "14:00", "2 PM", "12:34 AM", "noon", "10 am")
      - info_type (for STORE_INFO intent: "address" for address-related requests, "hours" for operating hours or schedule requests, "services" for service-related requests, "packages" for package-related requests)
      - phone_number (for PROVIDE_PHONE_NUMBER intent: the phone number provided, e.g., "96460132")

      Focus on identifying the primary service name even if the message includes extra words (e.g., "haircut maybe" should be "haircut") or informal terms (e.g., "cut" should be interpreted as "haircut", "nails" as "manicure"). If unsure, prioritize the most likely service based on context.

      Customer message: "${message}"

      Respond in JSON format:
      {
        "intent": "INTENT_NAME",
        "details": {
          "store_name": "STORE_NAME or null",
          "service_name": "SERVICE_NAME or null",
          "date": "DATE or null",
          "time": "TIME or null",
          "info_type": "INFO_TYPE or null",
          "phone_number": "PHONE_NUMBER or null"
        }
      }
    `

    const completion = await openai.chat.completions.create({
      model: 'deepseek-chat',
      messages: [
        { role: 'system', content: 'You are a helpful assistant for Glamour Salon specializing in understanding customer intents from natural language with a focus on flexible service name and date/time recognition' },
        { role: 'user', content: prompt }
      ],
      temperature: 0.5,
      max_tokens: 200,
    })

    let responseContent = completion.choices[0].message.content.trim()
    if (responseContent.startsWith('```json')) {
      responseContent = responseContent.replace(/^```json\n/, '').replace(/\n```$/, '')
    }

    const result = JSON.parse(responseContent)
    console.log('Intent classification result:', result)
    return result
  } catch (error) {
    console.error('DeepSeek intent classification error:', error.message)
    const lowerMessage = message.toLowerCase()

    if (currentState.step === 'book_appointment' && (lowerMessage.includes('idle') || lowerMessage.includes('glamour'))) {
      return {
        intent: 'BOOK_APPOINTMENT',
        details: {
          store_name: lowerMessage.includes('idle') ? 'Idle' : 'Glamour Salon',
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (currentState.step === 'store_info' && (lowerMessage.includes('idle') || lowerMessage.includes('glamour'))) {
      return {
        intent: 'STORE_INFO',
        details: {
          store_name: lowerMessage.includes('idle') ? 'Idle' : 'Glamour Salon',
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (currentState.step === 'selectOption') {
      let infoType = null
      if (lowerMessage.includes('address')) infoType = 'address'
      else if (lowerMessage.includes('hours') || lowerMessage.includes('opening') || lowerMessage.includes('operating')) infoType = 'hours'
      else if (lowerMessage.includes('services') || lowerMessage.includes('offer')) infoType = 'services'
      else if (lowerMessage.includes('packages') || lowerMessage.includes('package')) infoType = 'packages'

      if (infoType) {
        return {
          intent: 'STORE_INFO',
          details: {
            store_name: currentState.storeName || null,
            service_name: null,
            date: null,
            time: null,
            info_type: infoType,
            phone_number: null
          }
        }
      }
    } else if (currentState.step === 'book_appointment_service' && (lowerMessage.includes('haircut') || lowerMessage.includes('manicure') || lowerMessage.includes('cut') || lowerMessage.includes('nails'))) {
      return {
        intent: 'BOOK_APPOINTMENT',
        details: {
          store_name: null,
          service_name: lowerMessage.includes('haircut') || lowerMessage.includes('cut') ? 'haircut' : 'manicure',
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (currentState.step === 'book_appointment_datetime' && (lowerMessage.includes('tomorrow') || lowerMessage.includes('friday') || lowerMessage.match(/\d{1,2}(?::\d{2})?\s*(am|pm)/i))) {
      return {
        intent: 'BOOK_APPOINTMENT',
        details: {
          store_name: null,
          service_name: null,
          date: lowerMessage.includes('tomorrow') ? 'tomorrow' : (lowerMessage.includes('friday') ? 'Friday' : null),
          time: lowerMessage.match(/\d{1,2}(?::\d{2})?\s*(am|pm)/i)?.[0] || null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (currentState.step === 'package_inquiry' && currentState.phoneNumberRequested && message.match(/^\d+$/)) {
      return {
        intent: 'PROVIDE_PHONE_NUMBER',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: message
        }
      }
    } else if (lowerMessage.includes('book') || lowerMessage.includes('appointment') || lowerMessage.includes('schedule') || lowerMessage.includes('service') || lowerMessage.includes('make a booking')) {
      return {
        intent: 'BOOK_APPOINTMENT',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (lowerMessage.includes('change') || lowerMessage.includes('reschedule') || lowerMessage.includes('modify') || lowerMessage.includes('move my appointment')) {
      return {
        intent: 'CHANGE_APPOINTMENT',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (lowerMessage.includes('details') || lowerMessage.includes('info') || lowerMessage.includes('hours') || lowerMessage.includes('address') || lowerMessage.includes('services') || lowerMessage.includes('what do you offer') || lowerMessage.includes('store details')) {
      let infoType = null
      if (lowerMessage.includes('hours') || lowerMessage.includes('schedule')) infoType = 'hours'
      else if (lowerMessage.includes('address')) infoType = 'address'
      else if (lowerMessage.includes('services') || lowerMessage.includes('offer')) infoType = 'services'
      else if (lowerMessage.includes('packages') || lowerMessage.includes('package')) infoType = 'packages'

      return {
        intent: 'STORE_INFO',
        details: {
          store_name: lowerMessage.includes('idle') ? 'Idle' : (lowerMessage.includes('glamour') ? 'Glamour Salon' : null),
          service_name: null,
          date: null,
          time: null,
          info_type: infoType,
          phone_number: null
        }
      }
    } else if (lowerMessage.includes('upcoming') || lowerMessage.includes('appointments') || lowerMessage.includes('bookings') || lowerMessage.includes('my schedule') || lowerMessage.includes('what appointments do i have') || lowerMessage.includes('i want to see upcoming appointments')) {
      return {
        intent: 'VIEW_APPOINTMENTS',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (lowerMessage.toUpperCase() === 'YES' || lowerMessage.toLowerCase() === 'yes' || lowerMessage.toLowerCase() === 'confirm' || lowerMessage.toLowerCase() === 'i confirm') {
      return {
        intent: 'CONFIRM_APPOINTMENT',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (lowerMessage.toUpperCase() === 'NO' || lowerMessage.toLowerCase() === 'no' || lowerMessage.toLowerCase() === 'cancel' || lowerMessage.toLowerCase() === 'i want to cancel') {
      return {
        intent: 'CANCEL_APPOINTMENT',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (lowerMessage.includes('hello') || lowerMessage.includes('hi') || lowerMessage.includes('hey') || lowerMessage.includes('good morning') || lowerMessage.includes('good afternoon')) {
      return {
        intent: 'GREETING',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (lowerMessage.includes('package') || lowerMessage.includes('session') || lowerMessage.includes('credit') || lowerMessage.includes('active') || lowerMessage.includes('package status')) {
      return {
        intent: 'PACKAGE_INQUIRY',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (lowerMessage.toUpperCase() === 'YES' || lowerMessage.toLowerCase() === 'yes' || lowerMessage.toLowerCase() === 'sure' || lowerMessage.toLowerCase() === 'okay') {
      return {
        intent: 'REGISTER_CONFIRM',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    } else if (lowerMessage.toUpperCase() === 'NO' || lowerMessage.toLowerCase() === 'no' || lowerMessage.toLowerCase() === 'not now') {
      return {
        intent: 'REGISTER_DECLINE',
        details: {
          store_name: null,
          service_name: null,
          date: null,
          time: null,
          info_type: null,
          phone_number: null
        }
      }
    }

    return {
      intent: 'UNKNOWN',
      details: {
        store_name: null,
        service_name: null,
        date: null,
        time: null,
        info_type: null,
        phone_number: null
      }
    }
  }
}

async function extractNameAndNumber(message) {
  try {
    console.log('Extracting name and number from message:', message)
    const prompt = `
      You are a helpful assistant for Glamour Salon. Analyze the customer's message and extract the name and phone number. The message may contain a name and a phone number in various formats, such as:
      - "Name Number" (e.g., "John 96460132")
      - "Number Name" (e.g., "96460132 John")
      - "Name, Number" (e.g., "John, 96460132")
      - "My name is Name and my number is Number" (e.g., "My name is John and my number is 96460132")
      - "Number is my number and I'm Name" (e.g., "96460132 is my number and I'm John")
      
      The name will typically be a string of alphabetic characters (e.g., "John", "Advika"), and the phone number will be a sequence of digits, possibly starting with a country code like +65 (e.g., "96460132", "+6596460132").

      Customer message: "${message}"

      Respond in JSON format:
      {
        "name": "EXTRACTED_NAME or null",
        "phoneNumber": "EXTRACTED_PHONE_NUMBER or null"
      }
    `

    const completion = await openai.chat.completions.create({
      model: 'deepseek-chat',
      messages: [
        { role: 'system', content: 'You are a helpful assistant for Glamour Salon specializing in extracting customer names and phone numbers from natural language with a focus on flexible format recognition' },
        { role: 'user', content: prompt }
      ],
      temperature: 0.5,
      max_tokens: 100,
    })

    let responseContent = completion.choices[0].message.content.trim()
    if (responseContent.startsWith('```json')) {
      responseContent = responseContent.replace(/^```json\n/, '').replace(/\n```$/, '')
    }

    const result = JSON.parse(responseContent)
    console.log('Extracted name and number:', result)

    // Normalize phone number by removing country code if present
    if (result.phoneNumber) {
      result.phoneNumber = result.phoneNumber.replace(/^\+65/, '')
    }

    return result
  } catch (error) {
    console.error('DeepSeek name and number extraction error:', error.message)
    return { name: null, phoneNumber: null }
  }
}

app.post('/twilio-webhook', async (req, res) => {
  console.log('Webhook received:', req.body)
  const reply = req.body.Body
  const from = req.body.From.replace('whatsapp:', '')
  console.log(`Processing message from ${from}: ${reply}`)
  try {
    let fromWithoutPrefix = from
    if (from.startsWith('+65')) {
      fromWithoutPrefix = from.slice(3)
    }

    let clientData = null
    let clientLink = null
    const { data: existingClient, error: clientError } = await supabase
      .schema('clients')
      .from('global_clients')
      .select('client_name, preferred_name, global_client_id, client_ph')
      .eq('client_ph', fromWithoutPrefix)
      .single()
    
    if (!clientError && existingClient) {
      clientData = existingClient
      const { data: existingClientLink, error: linkError } = await supabase
        .schema('clients')
        .from('clients')
        .select('client_id')
        .eq('global_client_id', clientData.global_client_id)
        .single()
      if (linkError || !existingClientLink) {
        console.error(`No client link found for global_client_id ${clientData.global_client_id}: ${linkError?.message}`)
        res.status(500).send('Error fetching client link')
        return
      }
      clientLink = existingClientLink
    }

    let responseMessage
    let name = clientData ? (clientData.preferred_name || clientData.client_name || 'there') : 'there'
    if (!clientData && req.body.ProfileName) {
      name = req.body.ProfileName
    }

    let currentState = conversationState.get(from) || {}
    console.log('Current state before intent classification:', currentState)

    const { intent, details } = await classifyIntent(reply, currentState)

    console.log('Detected intent:', intent)
    if (conversationState.has(from) && ['GREETING', 'BOOK_APPOINTMENT', 'VIEW_APPOINTMENTS', 'CHANGE_APPOINTMENT', 'STORE_INFO', 'PACKAGE_INQUIRY'].includes(intent)) {
      if (currentState.intent !== intent) {
        console.log('Resetting conversation state for new intent:', intent)
        conversationState.delete(from)
        currentState = { intent }
      } else {
        console.log('No state reset needed; continuing with same intent:', intent)
      }
    } else if (!conversationState.has(from)) {
      currentState = { intent }
    }

    conversationState.set(from, currentState)
    let state = conversationState.get(from) || {}
    console.log('Current conversation state after intent classification:', state)

    if (state.step === 'selectOption') {
      const { storeId, storeName } = state
      const { store, services, packages } = await fetchStoreInfo(storeId)

      if (reply === '1' || details.info_type === 'address') {
        responseMessage = `the address for ${storeName} is ${store.store_addressL1}`
        conversationState.delete(from)
      } else if (reply === '2' || details.info_type === 'hours') {
        const hours = store.store_operating_hours
        const formattedHours = Object.entries(hours)
          .map(([day, info]) => {
            if (info.isClosed) return `${day} closed`
            return `${day} ${info.open} to ${info.close}`
          })
          .join('\n')
        responseMessage = `here are the operating hours for ${storeName}\n${formattedHours}`
        conversationState.delete(from)
      } else if (reply === '3' || details.info_type === 'services') {
        const serviceList = services.map(s => `${s.service_name} $${s.price} ${s.service_duration} mins`).join('\n')
        responseMessage = `these are the services at ${storeName}\n${serviceList}`
        conversationState.delete(from)
      } else if (reply === '4' || details.info_type === 'packages') {
        const packageList = packages.map(p => {
          const startDate = new Date(p.package_start).toLocaleDateString()
          const endDate = new Date(p.package_end).toLocaleDateString()
          return `${p.package_name} $${p.package_price} ${p.num_sessions} sessions ${p.num_credits} credits valid ${startDate} to ${endDate} ${p.package_description}`
        }).join('\n')
        responseMessage = `here are the packages at ${storeName}\n${packageList}`
        conversationState.delete(from)
      } else {
        responseMessage = `please pick an option\n1 store address\n2 operating hours\n3 services\n4 packages`
      }
    } else if (state.step === 'store_info') {
      if (!state.storeName) {
        if (details.store_name) {
          console.log('Searching for store in store_info:', details.store_name)
          const { data: storeRecord, error: storeError } = await supabase
            .schema('store_management')
            .from('stores')
            .select('store_id, store_name')
            .ilike('store_name', `%${details.store_name.replace(' salon', '').trim()}%`)
            .single()
          if (storeError || !storeRecord) {
            console.error('Store search error in store_info:', storeError?.message || 'No store found')
            console.log('Store not found in database in store_info:', details.store_name)
            const { data: allStores, error: allStoresError } = await supabase
              .schema('store_management')
              .from('stores')
              .select('store_id, store_name')
            console.log('All stores in database:', allStores, 'Error:', allStoresError?.message)
            responseMessage = `sorry ${name} I couldn't find a store named ${details.store_name} can you try again`
          } else {
            console.log('Store found in store_info:', storeRecord)
            state.storeName = storeRecord.store_name
            state.storeId = storeRecord.store_id
            state.step = 'selectOption'
            conversationState.set(from, state)
            if (details.info_type === 'address') {
              const { store } = await fetchStoreInfo(state.storeId)
              responseMessage = `the address for ${state.storeName} is ${store.store_addressL1}`
              conversationState.delete(from)
            } else if (details.info_type === 'hours') {
              const { store } = await fetchStoreInfo(state.storeId)
              const hours = store.store_operating_hours
              const formattedHours = Object.entries(hours)
                .map(([day, info]) => {
                  if (info.isClosed) return `${day} closed`
                  return `${day} ${info.open} to ${info.close}`
                })
                .join('\n')
              responseMessage = `here are the operating hours for ${state.storeName}\n${formattedHours}`
              conversationState.delete(from)
            } else if (details.info_type === 'services') {
              const { services } = await fetchStoreInfo(state.storeId)
              const serviceList = services.map(s => `${s.service_name} $${s.price} ${s.service_duration} mins`).join('\n')
              responseMessage = `these are the services at ${state.storeName}\n${serviceList}`
              conversationState.delete(from)
            } else if (details.info_type === 'packages') {
              const { packages } = await fetchStoreInfo(state.storeId)
              const packageList = packages.map(p => {
                const startDate = new Date(p.package_start).toLocaleDateString()
                const endDate = new Date(p.package_end).toLocaleDateString()
                return `${p.package_name} $${p.package_price} ${p.num_sessions} sessions ${p.num_credits} credits valid ${startDate} to ${endDate} ${p.package_description}`
              }).join('\n')
              responseMessage = `here are the packages at ${state.storeName}\n${packageList}`
              conversationState.delete(from)
            } else {
              responseMessage = `I found ${state.storeName} what would you like to know about it\n1 store address\n2 operating hours\n3 services\n4 packages`
            }
          }
        } else {
          responseMessage = `I’d be happy to help with that ${name} which store would you like more details about maybe Idle or Glamour Salon`
        }
      }
    } else if (state.step === 'book_appointment') {
      if (!state.storeName) {
        if (details.store_name) {
          console.log('Searching for store in book_appointment:', details.store_name)
          const { data: storeRecord, error: storeError } = await supabase
            .schema('store_management')
            .from('stores')
            .select('store_id, store_name')
            .ilike('store_name', `%${details.store_name.replace(' salon', '').trim()}%`)
            .single()
          if (storeError || !storeRecord) {
            console.error('Store search error in book_appointment:', storeError?.message || 'No store found')
            console.log('Store not found in database in book_appointment:', details.store_name)
            const { data: allStores, error: allStoresError } = await supabase
              .schema('store_management')
              .from('stores')
              .select('store_id, store_name')
            console.log('All stores in database:', allStores, 'Error:', allStoresError?.message)
            responseMessage = `sorry ${name} I couldn't find a store named ${details.store_name} can you try again`
          } else {
            console.log('Store found in book_appointment:', storeRecord)
            state.storeName = storeRecord.store_name
            state.storeId = storeRecord.store_id
            state.step = 'book_appointment_service'
            conversationState.set(from, state)
            responseMessage = `great ${name} I found ${state.storeName} what service would you like to book today maybe a haircut or a manicure`
          }
        } else {
          responseMessage = `which store would you like to book at maybe Idle or Glamour Salon`
        }
      }
    } else if (state.step === 'book_appointment_service') {
      if (!state.serviceName) {
        const { data: services, error: servicesError } = await supabase
          .schema('store_management')
          .from('services')
          .select('service_id, service_name, service_duration')
          .eq('store_id', state.storeId)
        if (servicesError) throw servicesError
        let serviceMatch = services.find(s => s.service_name.toLowerCase() === details.service_name?.toLowerCase())
        if (!serviceMatch && details.service_name) {
          const lowerServiceName = details.service_name.toLowerCase()
          const serviceSynonyms = {
            'cut': 'haircut',
            'nails': 'manicure',
            'trim': 'haircut'
          }
          const normalizedService = serviceSynonyms[lowerServiceName] || lowerServiceName
          serviceMatch = services.find(s => s.service_name.toLowerCase().includes(normalizedService))
        }
        if (serviceMatch) {
          state.serviceName = serviceMatch.service_name
          state.serviceId = serviceMatch.service_id
          state.serviceDuration = serviceMatch.service_duration
          state.step = 'book_appointment_datetime'
          conversationState.set(from, state)
          responseMessage = `nice choice ${name} your ${state.serviceName} is available at ${state.storeName} when would you like to come in just say something like tomorrow at 2 PM or Friday at noon`
        } else {
          responseMessage = `sorry ${name} I couldn’t find the service ${details.service_name || reply} at ${state.storeName} did you mean something like haircut or manicure try again or let me know what you meant`
        }
      }
    } else if (state.step === 'book_appointment_datetime') {
      if (!state.date || !state.time) {
        if (details.date || details.time) {
          const dateTime = parseDateTime(details.date, details.time)
          if (dateTime && !isNaN(dateTime.getTime())) {
            const apptStart = dateTime
            const apptEnd = new Date(apptStart.getTime() + state.serviceDuration * 60 * 1000)

            const availability = await checkAvailabilityAndHours(state.storeId, apptStart, apptEnd, state.serviceDuration)
            if (!availability.isAvailable) {
              if (availability.reason === 'closed') {
                responseMessage = `sorry ${name} the store is closed on ${apptStart.toLocaleDateString()}`
              } else if (availability.reason === 'outside_hours') {
                responseMessage = `sorry ${name} the time on ${apptStart.toLocaleDateString()} at ${apptStart.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })} is outside our operating hours`
              } else if (availability.reason === 'fully_booked') {
                responseMessage = `sorry ${name} the time slot on ${apptStart.toLocaleDateString()} at ${apptStart.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })} is fully booked`
              }
              
              if (availability.suggestedTime) {
                responseMessage += ` how about ${availability.suggestedTime.date} at ${availability.suggestedTime.time} instead or let me know another time that works for you`
              } else {
                responseMessage += ` I couldn’t find an available slot soon can you try a different day or let me know when you’re free`
              }
            } else {
              if (!clientData) {
                state.step = 'collect_client_details'
                state.from = from
                state.appointmentDetails = {
                  storeId: state.storeId,
                  storeName: state.storeName,
                  serviceId: state.serviceId,
                  serviceName: state.serviceName,
                  apptStart: apptStart.toISOString(),
                  apptEnd: apptEnd.toISOString()
                }
                conversationState.set(from, state)
                responseMessage = `okay ${name} can I get your details please your phone number and name`
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
                  .select()
                if (error) throw error

                state.step = 'ask_to_register'
                state.appointmentDetails = {
                  storeId: state.storeId,
                  storeName: state.storeName,
                  serviceName: state.serviceName,
                  apptStart: apptStart.toISOString()
                }
                conversationState.set(from, state)
                responseMessage = `all set ${name} your ${state.serviceName} at ${state.storeName} is booked for ${apptStart.toLocaleDateString()} at ${apptStart.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })} would you like to save your details for easier bookings next time just say YES or NO`
              }
            }
          } else {
            responseMessage = `sorry ${name} I didn’t catch that date or time can you try again with something like tomorrow at 2 PM or this Friday at 10 am`
          }
        } else {
          responseMessage = `when would you like your ${state.serviceName} at ${state.storeName} just say something like tomorrow at 2 PM or this Friday at 10 am`
        }
      }
    } else if (state.step === 'collect_client_details') {
      const { name: clientName, phoneNumber } = await extractNameAndNumber(reply)
      if (clientName && phoneNumber) {
        if (phoneNumber !== fromWithoutPrefix) {
          responseMessage = `the phone number you gave ${phoneNumber} doesn’t match the one you’re messaging from ${fromWithoutPrefix} please use the same number or let me know if this is on purpose`
        } else {
          const { clientId, globalClientId } = await createClientRecord(from, clientName)
          if (state.intent === 'VIEW_APPOINTMENTS') {
            const { data: appointments, error: apptError } = await supabase
              .schema('appointments')
              .from('appointments')
              .select('appt_id, appt_start, service_id, store_id')
              .eq('client_id', clientId)
            if (apptError) throw apptError

            name = clientName
            if (!appointments || appointments.length === 0) {
              responseMessage = `hi ${name} looks like you don’t have any upcoming appointments would you like to book one now`
            } else {
              const apptDetails = await Promise.all(appointments.map(async (appt) => {
                const { data: store } = await supabase
                  .schema('store_management')
                  .from('stores')
                  .select('store_name')
                  .eq('store_id', appt.store_id)
                  .single()
                return `${appt.service_id} at ${store.store_name} on ${new Date(appt.appt_start).toLocaleDateString()} at ${new Date(appt.appt_start).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })}`
              }))
              responseMessage = `hi ${name} here are your upcoming appointments\n${apptDetails.join('\n')}`
            }
            conversationState.delete(from)
          } else if (state.intent === 'CHANGE_APPOINTMENT') {
            const { data: apptData, error: apptError } = await supabase
              .schema('appointments')
              .from('appointments')
              .select('appt_id, appt_start, appt_end, service_id')
              .eq('client_id', clientId)
              .order('appt_start', { ascending: false })
              .limit(1)
              .single()
            if (apptError || !apptData) {
              responseMessage = `sorry ${name} I couldn’t find an appointment to change would you like to book a new one instead`
              conversationState.delete(from)
            } else {
              state.step = 'change_appointment'
              state.clientId = clientId
              conversationState.set(from, state)
              responseMessage = `let’s reschedule your ${apptData.service_id} appointment ${name} when would you like it just say something like tomorrow at 2 PM or this Friday at 10 am`
            }
          } else if (state.intent === 'CONFIRM_APPOINTMENT') {
            const { data: apptData, error: apptError } = await supabase
              .schema('appointments')
              .from('appointments')
              .select('appt_id, appt_start, service_id')
              .eq('client_id', clientId)
              .order('appt_start', { ascending: false })
              .limit(1)
              .single()
            if (apptError || !apptData) {
              responseMessage = `sorry ${name} I couldn’t find an appointment to confirm would you like to book a new one`
              conversationState.delete(from)
            } else {
              await supabase
                .schema('appointments')
                .from('appointments')
                .update({ status: 'confirmed' })
                .eq('appt_id', apptData.appt_id)
              responseMessage = `thanks ${name} your ${apptData.service_id} appointment on ${new Date(apptData.appt_start).toLocaleDateString()} at ${new Date(apptData.appt_start).toLocaleTimeString()} is confirmed`
              conversationState.delete(from)
            }
          } else if (state.intent === 'CANCEL_APPOINTMENT') {
            const { data: apptData, error: apptError } = await supabase
              .schema('appointments')
              .from('appointments')
              .select('appt_id, appt_start, service_id')
              .eq('client_id', clientId)
              .order('appt_start', { ascending: false })
              .limit(1)
              .single()
            if (apptError || !apptData) {
              responseMessage = `sorry ${name} I couldn’t find an appointment to cancel would you like to book a new one`
              conversationState.delete(from)
            } else {
              await supabase
                .schema('appointments')
                .from('appointments')
                .delete()
                .eq('appt_id', apptData.appt_id)
              responseMessage = `sorry to hear that ${name} your ${apptData.service_id} appointment on ${new Date(apptData.appt_start).toLocaleDateString()} at ${new Date(apptData.appt_start).toLocaleTimeString()} has been canceled`
              conversationState.delete(from)
            }
          } else {
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
              .select()
            if (error) throw error

            name = clientName
            state.globalClientId = globalClientId
            state.step = 'ask_to_register'
            conversationState.set(from, state)
            responseMessage = `wonderful ${name} your ${state.appointmentDetails.serviceName} at ${state.appointmentDetails.storeName} is booked for ${new Date(state.appointmentDetails.apptStart).toLocaleDateString()} at ${new Date(state.appointmentDetails.apptStart).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })} would you like to save your details for easier bookings next time just say YES or NO`
          }
        }
      } else {
        responseMessage = `sorry ${name} I didn’t get that please give your name and phone number like this Name Number for example John 96460132`
      }
    } else if (state.step === 'ask_to_register') {
      if (intent === 'REGISTER_CONFIRM') {
        state.step = 'collect_registration_details'
        conversationState.set(from, state)
        responseMessage = `great ${name} let’s get your details saved please share your preferred name if different from ${name} and your gender if you’d like for example Preferred Name Gender like Jane female or just say skip to keep it as is`
      } else if (intent === 'REGISTER_DECLINE') {
        responseMessage = `no worries ${name} your booking is still confirmed see you soon`
        conversationState.delete(from)
      } else {
        responseMessage = `would you like to save your details for easier bookings next time just say YES or NO`
      }
    } else if (state.step === 'collect_registration_details') {
      if (reply.toLowerCase() === 'skip') {
        if (state.globalClientId && state.appointmentDetails.storeId) {
          await linkClientToStore(state.globalClientId, state.appointmentDetails.storeId)
        }
        responseMessage = `all done ${name} your details are saved see you at your appointment`
        conversationState.delete(from)
      } else {
        const detailsMatch = reply.match(/([a-zA-Z\s]+)(?:,\s*(male|female|other))?/i)
        if (detailsMatch) {
          const preferredName = detailsMatch[1].trim()
          const gender = detailsMatch[2] ? detailsMatch[2].toLowerCase() : null
          const { error } = await supabase
            .schema('clients')
            .from('global_clients')
            .update({
              preferred_name: preferredName !== name ? preferredName : null,
              gender: gender
            })
            .eq('global_client_id', state.globalClientId)
          if (error) throw error

          if (state.globalClientId && state.appointmentDetails.storeId) {
            await linkClientToStore(state.globalClientId, state.appointmentDetails.storeId)
          }
          responseMessage = `thanks ${preferredName || name} your details are saved see you at your appointment`
          conversationState.delete(from)
        } else {
          responseMessage = `please share your preferred name if different from ${name} and your gender if you’d like for example Preferred Name Gender like Jane female or just say skip to keep it as is`
        }
      }
    } else if (state.step === 'change_appointment') {
      const clientId = state.clientId || clientLink.client_id
      const { data: apptData, error: apptError } = await supabase
        .schema('appointments')
        .from('appointments')
        .select('appt_id, appt_start, appt_end, service_id')
        .eq('client_id', clientId)
        .order('appt_start', { ascending: false })
        .limit(1)
        .single()
      if (apptError || !apptData) {
        responseMessage = `sorry ${name} I couldn’t find an appointment to change would you like to book a new one instead`
        conversationState.delete(from)
      } else {
        if (details.date || details.time) {
          const dateTime = parseDateTime(details.date, details.time)
          if (dateTime && !isNaN(dateTime.getTime())) {
            const apptStart = dateTime
            const apptEnd = new Date(apptStart.getTime() + (apptData.appt_end - apptData.appt_start))
            await supabase
              .schema('appointments')
              .from('appointments')
              .update({ appt_start: apptStart.toISOString(), appt_end: apptEnd.toISOString() })
              .eq('appt_id', apptData.appt_id)
            responseMessage = `all set ${name} your ${apptData.service_id} appointment is now rescheduled to ${apptStart.toLocaleDateString()} at ${apptStart.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })}`
            conversationState.delete(from)
          } else {
            responseMessage = `sorry ${name} I didn’t get that date or time please try again with something like tomorrow at 2 PM or this Friday at 10 am`
          }
        } else {
          responseMessage = `when would you like to reschedule your ${apptData.service_id} appointment just let me know with something like tomorrow at 2 PM or this Friday at 10 am`
        }
      }
    } else if (state.step === 'package_inquiry') {
      if (!state.phoneNumberRequested) {
        state.phoneNumberRequested = true
        conversationState.set(from, state)
        responseMessage = `I’d love to help with your package details ${name} can you please give me your registered phone number like 96460132 so I can look it up`
      } else if (intent === 'PROVIDE_PHONE_NUMBER') {
        const phoneNumber = details.phone_number
        const { data: globalClient, error: globalError } = await supabase
          .schema('clients')
          .from('global_clients')
          .select('global_client_id')
          .eq('client_ph', phoneNumber)
          .single()
        if (globalError || !globalClient) {
          responseMessage = `sorry ${name} I couldn’t find a client with the phone number ${phoneNumber} please try again with your registered number or contact support`
          conversationState.delete(from)
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
            .eq('global_client_id', globalClient.global_client_id)
          if (packageError || !clientPackages || clientPackages.length === 0) {
            responseMessage = `looks like you don’t have any active packages ${name} would you like to purchase one`
            conversationState.delete(from)
          } else {
            const packageDetails = await Promise.all(clientPackages.map(async (pkg) => {
              const { data: store, error: storeError } = await supabase
                .schema('store_management')
                .from('stores')
                .select('store_name')
                .eq('store_id', pkg.store_id)
                .single()
              if (storeError) throw storeError

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
                .single()
              if (packageInfoError) throw packageInfoError

              const purchaseDate = new Date(pkg.purchase_date).toLocaleDateString()
              const packageStart = new Date(packageInfo.package_start).toLocaleDateString()
              const packageEnd = new Date(packageInfo.package_end).toLocaleDateString()

              return `package ${packageInfo.package_name} at ${store.store_name}\n` +
                     `description ${packageInfo.package_description}\n` +
                     `price $${packageInfo.package_price}\n` +
                     `total sessions ${packageInfo.num_sessions} sessions remaining ${pkg.session_remaining}\n` +
                     `total credits ${packageInfo.num_credits} credits remaining ${pkg.credits_remaining}\n` +
                     `purchased on ${purchaseDate}\n` +
                     `valid from ${packageStart} to ${packageEnd}\n` +
                     `status ${pkg.status}`
            }))
            responseMessage = `here are your package details ${name}\n${packageDetails.join('\n\n')} let me know if you need more info`
            conversationState.delete(from)
          }
        }
      } else {
        responseMessage = `I’d love to help with your package details ${name} can you please give me your registered phone number like 96460132 so I can look it up`
      }
    } else {
      if (intent === 'GREETING') {
        responseMessage = `hello ${name} how can I assist you today you can book an appointment change an appointment get store info or check your package details just let me know what you'd like`
        conversationState.set(from, { intent: 'GREETING' })
      } else if (intent === 'BOOK_APPOINTMENT') {
        state.step = 'book_appointment'
        state.intent = 'BOOK_APPOINTMENT'
        conversationState.set(from, state)
        responseMessage = `I’d be happy to book an appointment for you ${name} which store would you like to book at maybe Idle or Glamour Salon`
      } else if (intent === 'VIEW_APPOINTMENTS') {
        if (!clientData) {
          state.step = 'collect_client_details'
          state.from = from
          state.intent = 'VIEW_APPOINTMENTS'
          conversationState.set(from, state)
          responseMessage = `okay ${name} can I get your details please your phone number and name`
        } else {
          const { data: appointments, error: apptError } = await supabase
            .schema('appointments')
            .from('appointments')
            .select('appt_id, appt_start, service_id, store_id')
            .eq('client_id', clientLink.client_id)
            .gt('appt_start', new Date().toISOString())
          if (apptError) throw apptError

          if (!appointments || appointments.length === 0) {
            responseMessage = `hi ${name} looks like you don’t have any upcoming appointments would you like to book one now`
          } else {
            const apptDetails = await Promise.all(appointments.map(async (appt) => {
              const { data: store } = await supabase
                .schema('store_management')
                .from('stores')
                .select('store_name')
                .eq('store_id', appt.store_id)
                .single()
              return `${appt.service_id} at ${store.store_name} on ${new Date(appt.appt_start).toLocaleDateString()} at ${new Date(appt.appt_start).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit', hour12: true })}`
            }))
            responseMessage = `hi ${name} here are your upcoming appointments\n${apptDetails.join('\n')}`
          }
          conversationState.delete(from)
        }
      } else if (intent === 'CHANGE_APPOINTMENT') {
        if (!clientData) {
          state.step = 'collect_client_details'
          state.from = from
          state.intent = 'CHANGE_APPOINTMENT'
          conversationState.set(from, state)
          responseMessage = `okay ${name} can I get your details please your phone number and name`
        } else {
          const { data: apptData, error: apptError } = await supabase
            .schema('appointments')
            .from('appointments')
            .select('appt_id, appt_start, appt_end, service_id')
            .eq('client_id', clientLink.client_id)
            .order('appt_start', { ascending: false })
            .limit(1)
            .single()
          if (apptError || !apptData) {
            responseMessage = `sorry ${name} I couldn’t find an appointment to change would you like to book a new one instead`
            conversationState.delete(from)
          } else {
            state.step = 'change_appointment'
            state.intent = 'CHANGE_APPOINTMENT'
            conversationState.set(from, state)
            responseMessage = `let’s reschedule your ${apptData.service_id} appointment ${name} when would you like it just say something like tomorrow at 2 PM or this Friday at 10 am`
          }
        }
      } else if (intent === 'CONFIRM_APPOINTMENT') {
        if (!clientData) {
          state.step = 'collect_client_details'
          state.from = from
          state.intent = 'CONFIRM_APPOINTMENT'
          conversationState.set(from, state)
          responseMessage = `okay ${name} can I get your details please your phone number and name`
        } else {
          const { data: apptData, error: apptError } = await supabase
            .schema('appointments')
            .from('appointments')
            .select('appt_id, appt_start, service_id')
            .eq('client_id', clientLink.client_id)
            .order('appt_start', { ascending: false })
            .limit(1)
            .single()
          if (apptError || !apptData) {
            responseMessage = `sorry ${name} I couldn’t find an appointment to confirm would you like to book a new one`
            conversationState.delete(from)
          } else {
            await supabase
              .schema('appointments')
              .from('appointments')
              .update({ status: 'confirmed' })
              .eq('appt_id', apptData.appt_id)
            responseMessage = `thanks ${name} your ${apptData.service_id} appointment on ${new Date(apptData.appt_start).toLocaleDateString()} at ${new Date(apptData.appt_start).toLocaleTimeString()} is confirmed`
            conversationState.delete(from)
          }
        }
      } else if (intent === 'CANCEL_APPOINTMENT') {
        if (!clientData) {
          state.step = 'collect_client_details'
          state.from = from
          state.intent = 'CANCEL_APPOINTMENT'
          conversationState.set(from, state)
          responseMessage = `okay ${name} can I get your details please your phone number and name`
        } else {
          const { data: apptData, error: apptError } = await supabase
            .schema('appointments')
            .from('appointments')
            .select('appt_id, appt_start, service_id')
            .eq('client_id', clientLink.client_id)
            .order('appt_start', { ascending: false })
            .limit(1)
            .single()
          if (apptError || !apptData) {
            responseMessage = `sorry ${name} I couldn’t find an appointment to cancel would you like to book a new one`
            conversationState.delete(from)
          } else {
            await supabase
              .schema('appointments')
              .from('appointments')
              .delete()
              .eq('appt_id', apptData.appt_id)
            responseMessage = `sorry to hear that ${name} your ${apptData.service_id} appointment on ${new Date(apptData.appt_start).toLocaleDateString()} at ${new Date(apptData.appt_start).toLocaleTimeString()} has been canceled`
            conversationState.delete(from)
          }
        }
      } else if (intent === 'STORE_INFO') {
        state.step = 'store_info'
        state.intent = 'STORE_INFO'
        if (details.store_name) state.storeName = details.store_name
        if (details.info_type) state.info_type = details.info_type
        conversationState.set(from, state)
        responseMessage = `I’d be happy to help with that ${name} which store would you like more details about maybe Idle or Glamour Salon`
      } else if (intent === 'PACKAGE_INQUIRY') {
        state.step = 'package_inquiry'
        state.intent = 'PACKAGE_INQUIRY'
        state.phoneNumberRequested = false
        conversationState.set(from, state)
        responseMessage = `I’d love to help with your package details ${name} can you please give me your registered phone number like 96460132 so I can look it up`
      } else {
        responseMessage = `sorry ${name} I’m not sure what you meant you can book an appointment change an appointment get store info or check your package details just let me know how I can help`
        conversationState.delete(from)
      }
    }

    const rephrasedMessage = await rephraseWithDeepSeek(responseMessage, name, state.storeName)
    console.log('Sending response:', rephrasedMessage)

    const twiml = new twilio.twiml.MessagingResponse()
    twiml.message(rephrasedMessage)
    res.set('Content-Type', 'text/xml')
    res.send(twiml.toString())
  } catch (error) {
    console.error('Error processing webhook:', error.message)
    const twiml = new twilio.twiml.MessagingResponse()
    twiml.message(`sorry I ran into an issue please try again or contact support`)
    res.set('Content-Type', 'text/xml')
    res.send(twiml.toString())
  }
})

app.listen(3000, () => {
  console.log('Server running on port 3000')
})

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
        appt_id
        store_id
        assignment_id
        client_id
        service_id
        appt_start
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
        .select('client_name preferred_name client_ph')
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
      .select('store_id store_name store_operating_hours store_addressL1')
      .eq('store_id', storeId)
      .single()
    if (storeError) throw storeError
    console.log('Store fetched:', store)

    const { data: services, error: servicesError } = await supabase
      .schema('store_management')
      .from('services')
      .select('service_id service_name service_description price service_duration')
      .eq('store_id', storeId)
    if (servicesError) throw servicesError
    console.log('Services fetched:', services.length)

    const { data: packages, error: packagesError } = await supabase
      .schema('store_management')
      .from('packages')
      .select('package_id package_name package_description package_limit package_type num_sessions num_credits package_price services_linked package_start package_end')
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
        store_id: null
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
          console.error(`Failed to send reminder to ${appt.client_name}:`,

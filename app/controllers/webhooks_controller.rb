# app/controllers/webhooks_controller.rb
  class WebhooksController < ApplicationController
    skip_before_action :verify_authenticity_token # Disable CSRF for webhook

    def whatsapp
      payload = JSON.parse(request.body.read)
      Rails.logger.info "Received WhatsApp webhook: #{payload.inspect}"

      # Store message in Supabase
      client = Supabase::Client.new
      client.from('realtime.messages').insert(
        sender: payload['sender'] || payload['from'],
        content: payload['message'] || payload['body'],
        created_at: Time.now
      ).execute

      render json: { status: 'received' }, status: :ok
    rescue StandardError => e
      Rails.logger.error "Webhook error: #{e.message}"
      render json: { error: 'Webhook processing failed' }, status: :unprocessable_entity
    end
  end
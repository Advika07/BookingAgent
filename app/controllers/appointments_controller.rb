# app/controllers/appointments_controller.rb
class AppointmentsController < ApplicationController
    # Fake in-memory appointment store
    APPOINTMENTS = []
  
    def create
      appointment = {
        name: params[:name],
        time: params[:time]
      }
      APPOINTMENTS << appointment
  
      # Mock follow-up log
      Rails.logger.info("Follow-up scheduled for #{appointment[:name]} at #{appointment[:time]}")
  
      render json: { message: "Appointment booked for #{appointment[:time]}" }
    end
  end
  
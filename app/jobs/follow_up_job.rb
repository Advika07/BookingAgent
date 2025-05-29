# app/jobs/follow_up_job.rb
class FollowUpJob < ApplicationJob
    queue_as :default
  
    def perform(appointment_id)
      appointment = Appointment.find(appointment_id)
      # Send follow-up (just log or trigger notification)
      Rails.logger.info("Reminder: Follow-up with #{appointment.name} for appointment at #{appointment.time}")
    end
  end
  
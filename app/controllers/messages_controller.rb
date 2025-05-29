# app/controllers/messages_controller.rb
class MessagesController < ApplicationController

  SERVICES = {
    "Women's Haircut" => 45,
    "Men's Haircut" => 35,
    "Hair Coloring" => 80,
    "Blow Dry" => 30,
    "Hair Treatment" => 60
  }

  SCHEDULE = {
    "Monday" => ["10:00 AM", "11:00 AM", "2:00 PM", "4:00 PM"],
    "Tuesday" => ["9:00 AM", "1:00 PM", "3:00 PM"],
    "Wednesday" => ["10:00 AM", "12:00 PM", "5:00 PM"],
    "Thursday" => ["11:00 AM", "2:00 PM", "4:00 PM"],
    "Friday" => ["9:00 AM", "1:00 PM", "3:00 PM"],
    "Saturday" => ["10:00 AM", "12:00 PM", "2:00 PM"],
    "Sunday" => []
  }

  def create
    user_message = params[:message].to_s.downcase

    case
    when user_message.include?("price") || user_message.include?("cost")
      response = "Here are our services and prices:\n"
      SERVICES.each do |service, price|
        response += "- #{service}: $#{price}\n"
      end
      render json: { intent: "service_pricing", response: response }

    when user_message.include?("available") || user_message.include?("slots") || user_message.include?("schedule")
      response = "Here are our available appointment slots:\n"
      SCHEDULE.each do |day, times|
        next if times.empty?
        response += "#{day}:\n"
        times.each do |time|
          response += "  - #{time}\n"
        end
      end
      render json: { intent: "availability", response: response }

    when user_message.include?("book") || user_message.include?("appointment")
      response = "Sure! To book an appointment, please let us know the service you'd like and your preferred date and time."
      render json: { intent: "booking_request", response: response }

    else
      response = "Thanks for reaching out! How can I assist you today?"
      render json: { intent: "general", response: response }
    end
  end

end

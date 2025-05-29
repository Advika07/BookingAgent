Rails.application.routes.draw do
  post '/messages', to: 'messages#create'
  post '/appointments', to: 'appointments#create'
  post '/webhooks/whatsapp', to: 'webhooks#whatsapp'
  namespace :api do
    resources :stores, only: [:index] # Adjust based on your needs
end
end
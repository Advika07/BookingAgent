# config/application.rb
require_relative "boot"

# Only require the railties you actually need:
require "action_controller/railtie"
require "action_mailer/railtie"
require "rails/test_unit/railtie"

# Uncomment if using Sidekiq (remove if not needed)
# require "active_job/railtie"

# Comment out ActiveRecord since we're not using a database
# require "active_record/railtie"

Bundler.require(*Rails.groups)

module IdleDemoBackend
  class Application < Rails::Application
    config.load_defaults 7.0

    # This is an API-only app, strip out unnecessary middleware
    config.api_only = true

    # If you want to add middleware like Rack::Cors for cross-origin requests (for Flutter frontend)
    # Uncomment below:

    # config.middleware.insert_before 0, Rack::Cors do
    #   allow do
    #     origins '*'
    #     resource '*',
    #       headers: :any,
    #       methods: [:get, :post, :put, :patch, :delete, :options, :head]
    #   end
    # end
  end
end

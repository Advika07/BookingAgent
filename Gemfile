source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.7"

# Core Rails gems
gem "rails", "~> 7.1.0"
gem "puma", "~> 6.0"

# Database and ORM
gem "pg"
gem 'solid_queue'
gem 'solid_cache'

# Authentication and Authorization
gem "devise"
gem "jwt"
gem "bcrypt"
gem 'omniauth-auth0'
gem 'omniauth-rails_csrf_protection', '~> 1.0'

# API Development
gem "rack-cors"
gem "jbuilder"
gem "oj"
gem "rswag"

# Background Processing
gem "sidekiq"
gem "redis"
gem "redis-namespace"

# Monitoring and Error Tracking
gem "sentry-ruby"
gem "sentry-rails"
gem "newrelic_rpm"

# Utilities
gem 'dotenv-rails', groups: [:development, :test]
gem "faker"
gem "active_model_serializers"
gem "phonelib"
gem "time_difference"
gem "tzinfo-data"
gem 'stripe'

# Performance
gem "bootsnap", require: false

# Development and Testing
group :development, :test do
  gem "debug"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rubocop"
  gem "brakeman"
  gem "bullet"
end

group :development do
  gem "rack-mini-profiler"
  gem "spring"
end

group :test do
  gem "database_cleaner"
  gem "shoulda-matchers"
  gem "vcr"
  gem "webmock"
end

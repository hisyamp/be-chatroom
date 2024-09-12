require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    # Load Dotenv only in development or test environment
    # if Rails.env.development? || Rails.env.test?
    #   Dotenv::Railtie.load
    # end

     # CORS configuration
     config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*' # Allow requests from any origin
        resource '*', # Allow requests to any resource
          headers: :any, # Allow any headers
          methods: [:get, :post, :put, :patch, :delete, :options, :head], # Allow these HTTP methods
          expose: ['Authorization'], # Expose any custom headers (optional)
          max_age: 600
      end
    end
    # Other configurations...
  end
end

require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Xims
  class Application < Rails::Application
    # By now we don't care about locale validation
    config.i18n.enforce_available_locales = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :es
    config.i18n.fallbacks = true
    config.i18n.fallbacks = [:en]

    require 'xims'

    config.autoload_paths += Dir["#{Rails.root}/lib"]

    if Rails.env.test? || Rails.env.development?
      config.middleware.insert_before Warden::Manager, Rack::Cors do
        allow do
          origins '*'
          resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
        end
      end

      # turn off csrf just for development purposes
      config.action_controller.allow_forgery_protection = false
    end

    if Rails.env.production?
      config.middleware.insert_before Warden::Manager, Rack::Cors do
        allow do
          origins 'segguro.herokuapp.com', 'localhost:9000'
          resource '*', :headers => :any, :methods => [:get, :post, :put, :delete, :options]
        end
      end

      # turn off csrf just for development purposes
      config.action_controller.allow_forgery_protection = false
    end
  end
end

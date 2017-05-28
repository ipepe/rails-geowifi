require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsAppStartingTemplate
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.jbuilder = false
    config.generators.helper = false
    config.generators.test_framework(:test_unit, fixture: false)
    config.generators.template_engine :slim

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options]
      end
    end

    def warsaw_area
      {
        latitude: (52.1..52.3),
        longitude: (20.8..21.2)
      }
    end
  end
end

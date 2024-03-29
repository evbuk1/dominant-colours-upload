# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SongkickElastic
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.autoload_paths << Rails.root.join('lib')
    config.generators do |generator|
      generator.orm :active_record, primary_key_type: :integer
    end
    config.active_record.schema_format = :sql
    config.hosts << 'sk-srv1.nortech-consulting.com'
    config.hosts << '127.0.0.1'
    config.hosts << 'localhost'
    config.hosts << 'www.example.com'
    config.hosts << 'gateway.nortech-consulting.com'
  end
end

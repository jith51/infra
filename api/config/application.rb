require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsInfraApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.autoload_paths << Rails.root.join('app/query_builder')
    # config.eager_load_paths << Rails.root.join("query_builder")
    # config.autoload_paths << "#{config.root}/app/models/class_definitions"
    # config.autoload_paths << "#{config.root}/app/query_builder"
    # += Rails.root.join("app", "models", "class_definitions")
    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.autoload_lib(ignore: %w(assets tasks))
    
    config.api_only = true

    config.cache_store = :redis_store, ENV['CACHE_URL'],
                         { namespace: 'front::cache' }

    config.active_job.queue_adapter = :sidekiq
  end
end

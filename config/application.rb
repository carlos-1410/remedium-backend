require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RemediumBackend
  class Application < Rails::Application
    config.active_record.cache_versioning = true
    config.api_only = true
    config.eager_load_paths << Rails.root.join("lib")
    config.load_defaults 7.0
    config.time_zone = "UTC"
  end
end

ActiveModelSerializers.config.adapter = :json

require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)


module Template
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end

module GoogleVisionTranscription
  class Application < Rails::Application
    # config.ADD_STUFF_HERE.api_key = ENV['2131312312313213132131']
  end
end

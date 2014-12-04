require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module DevPledge
  class Application < Rails::Application
    config.encoding = "utf-8"

    config.generators do |g|
      g.orm :active_record
      g.template_engine :haml
    end
    
    # config.time_zone = 'Central Time (US & Canada)'
  end
end

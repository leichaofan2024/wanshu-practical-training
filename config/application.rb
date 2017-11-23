require_relative 'boot'
require 'carrierwave'
require 'carrierwave/orm/activerecord'
require 'carrierwave/storage/ftp'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module WanshuPracticalTraining
  class Application < Rails::Application
    config.time_zone = "Beijing"
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    CarrierWave.configure do |config|
      config.ftp_host = "192.168.1.13"
      config.ftp_port = 22
      config.ftp_user = "wanshukeji"
      config.ftp_passwd = "wanshukeji"
      config.ftp_folder = "/E:/uploads"
      config.ftp_url = "http://192.168.174.130:3000/uploads"
      config.ftp_passive = false # false by default
      config.ftp_tls = false # false by default
    end
  end
end

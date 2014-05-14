require 'savon'
require "allegro/webapi/version"
require 'allegro/webapi/auction'
require 'allegro/webapi/client'
require 'allegro/webapi/user'
require 'allegro/webapi/search'
require 'allegro/webapi/category'
require 'yaml'



env_file = 'config/local_env.yml'
YAML.load(File.open(env_file)).each do |key, value|
  ENV[key] = value
end if File.exists?(env_file)

module Allegro
  module WebApi
    def self.client
      @client
    end

    def self.login(user_login, password, webapi_key, country_code)
      @client = Allegro::WebApi::Client.new do |config|
        config.user_login = user_login
        config.password = password
        config.webapi_key = webapi_key
        config.country_code = country_code
      end
      @client.login
    end
  end
end

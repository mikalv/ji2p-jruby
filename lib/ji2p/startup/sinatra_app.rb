require 'sinatra'
require 'sinatra/base'
#require 'sinatra/config_file'
require 'sinatra/contrib'
require 'sinatra/cookies'
require 'sinatra/json'
require 'sinatra/namespace'
require 'sinatra/reloader'
#require 'sinatra/webdav'
require 'better_errors'
require 'binding_of_caller'

module Ji2p
  module Startup
    class SinatraApp < Sinatra::Base
      APP_ROOT = File.expand_path('../..', __dir__) unless defined? APP_ROOT

      use Rack::Session::Cookie, :key => 'rack.session',
                           :domain => 'localhost',
                           :path => '/',
                           :expire_after => 2592000, # In seconds
                           :secret => 'kake'

      set :environments, %w{development test production staging}
      enable  :sessions, :logging
      set :sessions, true
      set :logging, true
      set :server, %w[puma webrick]
      set :app_file, __FILE__
      set :public_folder, Proc.new { File.join(APP_ROOT, 'public') }
      set :protection, :session => true
      unless ENV['APP_ENV'].nil?
        set :environment, ENV['APP_ENV']
      else
        set :environment, :development
      end


      configure :development do
        register Sinatra::Reloader

        use BetterErrors::Middleware
        BetterErrors.application_root = APP_ROOT

        set :reload_stuff, true
      end

      register Sinatra::Namespace
      #register Sinatra::ConfigFile

      helpers Sinatra::Cookies

      set :show_exceptions, false

      get '/' do
        json :sinatra => { :status => 'OK', :request => request.env.to_json }
      end

    end
  end
end
require 'sinatra'
require 'rack'
require 'puma'
require 'faye/websocket'

module Ji2p::Server
  class Api
    def initialize
      configure { set :server, :puma }

      Faye::WebSocket.load_adapter('puma')
      @puma = Rack::Handler.get('puma')
    end
  end
end
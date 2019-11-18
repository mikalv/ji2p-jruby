require_relative 'http.rb'

module Ji2p::Server
  class HttpServer

    def initialize(application, socket)
      @application = application
      @socket = socket
    end

    def run
      loop do
        begin
          monitor
        rescue Interrupt
          Ji2p.logger.log("INTERRUPTED")
          return
        end
      end
    end

    def monitor
      #selections, = IO.select(@sockets)
      #io, = selections
      io = @socket

      begin
        socket = io.accept
        http = Ji2p::Server::HTTP::new(socket, @application)
        http.handle
      ensure
        socket.close
      end
    end

  end
end

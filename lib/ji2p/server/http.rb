require 'rack'

module Ji2p::Server
  class HTTP
    VERSION = "HTTP/1.1" unless defined? VERSION
    CRLF = "\r\n" unless defined? CRLF

    def initialize(socket, application)
      @socket = socket
      @application = application
    end

    def parse
      matches = /\A(?<method>\S+)\s+(?<uri>\S+)\s+(?<version>\S+)#{CRLF}\Z/.match(@socket.readline)
      uri = URI.parse(matches[:uri])

      env = {
        "rack.errors" => $stderr,
        "rack.version" => Rack::VERSION,
        "rack.url_scheme" => uri.scheme || "http",
        "REQUEST_METHOD" => matches[:method],
        "REQUEST_URI" => matches[:uri],
        "HTTP_VERSION" => matches[:version],
        "QUERY_STRING" => uri.query || "",
        "SERVER_PORT" => uri.port || 80,
        "SERVER_NAME" => uri.host || "localhost",
        "PATH_INFO" => uri.path || "",
        "SCRIPT_NAME" => "",
      }

      while matches = /\A(?<key>[^:]+):\s*(?<value>.+)#{CRLF}\Z/.match(hl = @socket.readline)
        case matches[:key]
        when Rack::ContentType then env["CONTENT_TYPE"] = matches[:value]
        when Rack::ContentLength then env["CONTENT_LENGTH"] = Integer(matches[:value])
        else env["HTTP_" + matches[:key].tr("-", "_").upcase] ||= matches[:value]
        end
      end

      env["rack.input"] = StringIO.new(@socket.read(env["CONTENT_LENGTH"] || 0))

      return env #.map { |_,v| String.new v }
    end

    def handle
      env = parse

      status, headers, body = @application.call(env)

      time = Time.now.httpdate

      @socket.write "#{env['HTTP_VERSION']} #{status} #{Rack::Utils::HTTP_STATUS_CODES.fetch(status.to_i) { 'UNKNOWN' }}#{CRLF}"
      @socket.write "Date: #{time}#{CRLF}"
      @socket.write "Connection: close#{CRLF}"

      headers.each do |key, value|
        @socket.write "#{key}: #{value}#{CRLF}"
      end

      @socket.write(CRLF)

      body.each do |chunk|
        @socket.write(chunk)
      end

      Ji2p.logger.info("[#{time}] '#{env["REQUEST_METHOD"]} #{env["REQUEST_URI"]} #{env["HTTP_VERSION"]}' #{status}")
    end

  end
end
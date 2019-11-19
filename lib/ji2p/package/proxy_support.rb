# encoding: utf-8
require "uri"
require "java"
require "erb"

module Ji2p
  module Package
    module ProxySupport
      extend self

      # Apply HTTP_PROXY and HTTPS_PROXY to the current environment
      # this will be used by any JRUBY calls
      def apply_env_proxy_settings(settings)
        $stderr.puts("Using proxy #{settings}") if ENV["DEBUG"]
        scheme = settings[:protocol].downcase
        java.lang.System.setProperty("#{scheme}.proxyHost", settings[:host])
        java.lang.System.setProperty("#{scheme}.proxyPort", settings[:port].to_s)
        java.lang.System.setProperty("#{scheme}.proxyUsername", settings[:username].to_s)
        java.lang.System.setProperty("#{scheme}.proxyPassword", settings[:password].to_s)
      end

      def extract_proxy_values_from_uri(proxy_uri)
        {
          :protocol => proxy_uri.scheme,
          :host => proxy_uri.host,
          :port => proxy_uri.port,
          :username => proxy_uri.user,
          :password => proxy_uri.password
        }
      end

      def parse_proxy_string(proxy_string)
        proxy_uri = URI.parse(proxy_string)
        if proxy_uri.kind_of?(URI::HTTP) # URI::HTTPS is already a subclass of URI::HTTP
          proxy_uri
        else
          raise "Invalid proxy `#{proxy_uri}`. The URI is not HTTP/HTTPS."
        end
      end

      def get_proxy(key)
        ENV[key.downcase] || ENV[key.upcase]
      end

      def proxy_string_exists?(proxy)
        !proxy.nil? && !proxy.strip.empty?
      end
    end
  end
end
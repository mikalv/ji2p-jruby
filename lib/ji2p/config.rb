require 'ostruct'
require 'yaml'

module Ji2p
  class Config
    def method_missing(m, *args, &block)
    end

    def respond_to?(method_name, include_private = false)
    end

    def respond_to_missing?(method_name, *args)
    end
  end
end
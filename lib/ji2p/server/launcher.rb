require 'rack'

module Ji2p::Server
  class Launcher

    def initialize privateKeyData=nil
      generate_keypair if privateKeyData.nil?
      load_keypair privateKeyData unless privateKeyData.nil?
    end

    protected

    def generate_keypair
      @keypair = Ji2p::Control::Keypair.generate!
    end

    def load_keypair privateKeyData
      @keypair = Ji2p::Control::Keypair.load_from_stream! StringIO.new(privateKeyData)
    end

  end

  class RackConfigLauncher < Launcher

    def initialize privateKeyData, rackfile
      super(privateKeyData)
      @rack_config = rackfile.dup
    end

    def rack_application
      raw = File.read(@rack_config)
      builder = <<~BUILDER
      Rack::Builder.new do
        #{raw}
      end
      BUILDER
      eval(builder, nil, @rack_config)
    end
  end
end
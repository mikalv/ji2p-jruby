require 'java'
require 'base64'

module Ji2p::Control
  class TunnelCtrl
    def initialize obj, conf
      @tunnel = obj
      @conf = conf
    end

    def start!
      @tunnel.startTunnelBackground
    end

    def stop!
      @tunnel.stopTunnel
    end

    def base32
      @tunnel.myDestHashBase32
    end

    def base64
      @tunnel.myDestination
    end

    def destination
      @tunnel.myDestination
    end

    def raw
      @tunnel
    end

    def raw_conf
      @conf
    end

    def privateKey base64_armored = true
      d = I2PAppContext.getGlobalContext.getRouterDir.to_s
      filename = File.join d, @conf['privKeyFile']
      f = File.open filename, 'rb'
      data = f.read
      data = Base64.encode64(data) if base64_armored
      data
    end
  end
end

require 'java'

module Ji2p::Control
  class Dest
    java_import 'net.i2p.data.Destination'

    def initialize keypair=nil
      setKeypair(keypair) unless keypair.nil?
    end

    def setKeypair keypair
      return if keypair.nil?
      @keypair = keypair
      @dest = Java::NetI2pData::Destination.create keypair.inputstream
      #@dest.setPublicKey @keypair.pub
      #@dest.setSigningPublicKey @keypair.spub
      #@dest.setCertificate @keypair.cert
      #@dest.setPadding @keypair.padding
    end

    def base64
      @dest.toBase64
    end

    def base32
      @dest.toBase32
    end

    def raw
      @dest
    end

  end
end
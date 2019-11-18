require 'java'
require 'thread'
require File.expand_path('dest.rb', __dir__)

module Ji2p::Control
  java_import 'net.i2p.crypto.SigType'
  java_import 'net.i2p.crypto.EncType'
  java_import 'net.i2p.I2PAppContext'
  java_import 'net.i2p.data.SigningPublicKey'
  java_import 'net.i2p.data.SigningPrivateKey'
  java_import 'net.i2p.data.Certificate'
  java_import 'net.i2p.data.KeyCertificate'
  java_import 'net.i2p.data.PublicKey'
  java_import 'net.i2p.data.PrivateKey'
  java_import 'net.i2p.data.Destination'
  java_import 'net.i2p.crypto.KeyGenerator'
  java_import 'net.i2p.client.I2PClientFactory'
  java_import 'java.util.Properties'
  java_import 'java.lang.Thread'

  DEFAULT_SIG_TYPE = Java::NetI2pCrypto::SigType::EdDSA_SHA512_Ed25519 unless defined? DEFAULT_SIG_TYPE
  DEFAULT_ENC_TYPE = Java::NetI2pCrypto::EncType::ELGAMAL_2048 unless defined? DEFAULT_ENC_TYPE

  VALID_ENC_TYPES = Java::NetI2pCrypto::EncType.constants.map { |c| c.to_s }.freeze unless defined? VALID_ENC_TYPES
  VALID_SIG_TYPES = Java::NetI2pCrypto::SigType.constants.map { |c| c.to_s }.freeze unless defined? VALID_SIG_TYPES

  module KeyGen
    def self.genPKIkeys
      KeyGenerator.getInstance.generatePKIKeypair
    end

    def self.genSigningKeys(arg=nil)
      unless arg.nil?
        KeyGenerator.getInstance.generateSigningKeys arg
      else
        KeyGenerator.getInstance.generateSigningKeys
      end
    end
  end

  class Keypair
    attr_accessor :dest, :cert, :pub, :spub, :priv, :spriv

    def self.generate! sig=DEFAULT_SIG_TYPE
      ost = StringIO.new
      c = I2PClientFactory.createClient
      c.createDestination(ost.to_outputstream, sig)
      keystream = StringIO.new ost.string
      load_from_stream! keystream
    end

    def self.load_from_stream! keystream
      c = I2PClientFactory.createClient
      s = c.createSession(keystream.to_inputstream, Java::JavaUtil::Properties.new)
      pub = s.myDestination.getPublicKey
      spub = s.myDestination.getSigningPublicKey
      priv = s.decryptionKey
      spriv = s.privateKey
      # This will be equal to the content of a
      # net.i2p.data.PrivateKeyFile
      cert = s.myDestination.getCertificate
      new cert,pub,priv,spub,spriv,keystream.string
    end

    def initialize cert,pub,priv,spub,spriv,data
      @cert = cert
      @pub = pub
      @priv = priv
      @spub = spub
      @spriv = spriv
      @data = data
      @dest = Ji2p::Control::Dest.new
      @dest.setKeypair self
    end

    def inputstream
      stream = StringIO.new @data
      stream.to_inputstream
    end

    def destination
      @dest
    end

    def createSession opts=Java::JavaUtil::Properties.new
      c = I2PClientFactory.createClient
      @session = c.createSession(inputstream, opts)
      @session
    end

    def private_key_format
      @data
    end

    def padding_size
      ((Java::NetI2pData::SigningPublicKey::KEYSIZE_BYTES - @spub.length)
        + (Java::NetI2pData::PublicKey::KEYSIZE_BYTES - @pub.length))
    end

    def padding
      SecureRandom.random_bytes(padding_size).to_java_bytes
    end

    def write_file f
      f = File.open(f, 'wb') unless f.is_a? File
      f.write(@data)
      f.close
    end

    module Old
      def self.old_generate! sig=DEFAULT_SIG_TYPE, enc=DEFAULT_ENC_TYPE
        if sig.is_a? String
          unless VALID_SIG_TYPES.include? sig
            raise ArgumentError, 'Unknown signature type', caller
          end
          sig = Java::NetI2pCrypto::SigType.const_get sig
        end
        if enc.is_a? String
          unless VALID_ENC_TYPES.include? enc
            raise ArgumentError, 'Unknown encryption type', caller
          end
          enc = Java::NetI2pCrypto::EncType.const_get enc
        end
        ctx = I2PAppContext.getGlobalContext
        enckp = ctx.keyGenerator.generatePKIKeys enc
        pub = enckp.getPublic.to_java(Java::NetI2pData::PublicKey)
        priv = enckp.getPrivate.to_java(Java::NetI2pData::PrivateKey)
        if (sig != Java::NetI2pCrypto::SigType::DSA_SHA1) or (enc != Java::NetI2pCrypto::EncType::ELGAMAL_2048)
          unless sig.getPubkeyLen > 128
            cert = Java::NetI2pData::KeyCertificate.new sig,enc
          else
            raise ArgumentError, 'Wrong combination of enc/sig keys', caller
          end
        else
          cert = Java::NetI2pData::Certificate::NULL_CERT
        end
        signingkp = ctx.keyGenerator.generateSigningKeys sig.to_java
        #signingkp = KeyGen.genSigningKeys sig
        spub = signingkp[0].to_java(Java::NetI2pData::SigningPublicKey)
        spriv = signingkp[1].to_java(Java::NetI2pData::SigningPrivateKey)
        #cert.calculateHash
        data = old_getPrivateKeyFileFormat cert,pub,priv,spub,spriv
        new cert,pub,priv,spub,spriv,data
      end

      def self.old_getPrivateKeyFileFormat cert,pub,priv,spub,spriv
        out = StringIO.new
        outs = out.to_outputstream
        pub.writeBytes outs
        padding_size = ((Java::NetI2pData::SigningPublicKey::KEYSIZE_BYTES - spub.length)
                        + (Java::NetI2pData::PublicKey::KEYSIZE_BYTES - pub.length))
        if padding_size > 0
          outs.write SecureRandom.random_bytes(padding_size).to_java_bytes
        end
        spub.writeBytes outs
        cert.writeBytes outs
        priv.writeBytes outs
        spriv.writeBytes outs
        outs.flush
        outs.close
        StringIO.new out.string
      end

      def self.old_load_from_obj! obj
        pub   = Java::NetI2pData::PublicKey.new obj[:enc_type],obj[:public_key].to_java_bytes
        priv  = Java::NetI2pData::PrivateKey.new obj[:enc_type],obj[:private_key].to_java_bytes
        spub  = Java::NetI2pData::SigningPublicKey.new obj[:sig_type],obj[:signing_public_key].to_java_bytes
        spriv = Java::NetI2pData::SigningPrivateKey.new obj[:sig_type],obj[:signing_private_key].to_java_bytes
        cert  = Java::NetI2pData::KeyCertificate.new spub,pub
        data = old_getPrivateKeyFileFormat cert,pub,priv,spub,spriv
        new cert,pub,priv,spub,spriv,data
      end
    end

  end
end
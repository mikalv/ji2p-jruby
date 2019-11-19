require 'java'
require 'thread'
require_relative 'server.rb'

module Ji2p::Control
  java_import 'net.i2p.I2PAppContext'
  java_import 'net.i2p.client.I2PClientFactory'
  java_import 'net.i2p.client.streaming.I2PSocketManager'
  java_import 'net.i2p.client.streaming.I2PSocketManagerFactory'
  java_import 'net.i2p.client.streaming.IncomingConnectionFilter'
  java_import 'java.util.Properties'
  java_import 'java.lang.Thread'

  class SocketManager

    def self.defineManager! name, kp, opts=Java::JavaUtil::Properties.new, filter=IncomingConnectionFilter::ALLOW
      ctx = I2PAppContext.getGlobalContext
      session = kp.createSession opts
      new get_impl.new(ctx,session,opts,name,filter)
    end

    def connectTunnel
      @smgr.getSession.connect
    end

    def myDestination
      @smgr.getSession.myDestination
    end

    def leaseSet
      @smgr.getSession.leaseSet
    end

    def sessionId
      @smgr.getSession.sessionId
    end

    def supports_ls2?
      @smgr.getSession.supports_ls2?
    end

    def is_closed?
      @smgr.getSession.closed?
    end

    def session
      @smgr.session
    end

    def destroy
      @smgr.getSession.destroySession
    end

    def lookupDest dest
      @smgr.getSession.lookupDest dest
    end

    def getServerSocket
      SocketServer.new @smgr.getServerSocket
    end

    def raw
      @smgr
    end

    private

    def self.get_impl
      java_import('net.i2p.client.streaming.impl.I2PSocketManagerFull').first
    end

    def initialize smgr
      @smgr = smgr
    end

  end
end
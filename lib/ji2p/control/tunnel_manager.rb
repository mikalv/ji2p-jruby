require 'java'

require 'java'
require 'digest/sha1'

module Ji2p::Control
  class TunnelManager
    @@tunnelctrl = nil
    include_package 'net.i2p'
    include_package 'net.i2p.i2ptunnel'
    include_package 'net.i2p.client'

    def self.context
      I2PAppContext.getGlobalContext
    end

    def self.startTunnelWithConfig conf, createPrivKey = false
      unless ['client','httpclient','server','httpserver','sockstunnel'].include? conf['type']
        raise ArgumentError, 'Invalid i2p tunnel type!', caller
      end
      tctrl = TunnelController.new conf, '', createPrivKey
      TunnelCtrl.new tctrl, conf
    end

    def self.createNewConfig hash = Hash.new
      props = java.util.Properties.new
      dfl = {
        'option.maxPosts'=>'3',
        'option.i2cp.destination.sigType'=>'EdDSA_SHA512_Ed25519',
        'option.i2p.streaming.limitAction'=>'http',
        'description'=>'jruby-tunnel',
        'interface'=>'127.0.0.1',
        'type'=>'httpserver',
        'option.outbound.quantity'=>'4',
        'option.inbound.quantity'=>'4',
        'option.postBanTime'=>'1800',
        'targetPort'=>'8000',
        'option.postTotalBanTime'=>'600',
        'i2cpHost'=>'127.0.0.1',
        'option.postCheckTime'=>'300',
        'option.i2p.streaming.maxConnsPerHour'=>'40',
        'option.shouldBundleReplyInfo'=>'false',
        'option.outbound.length'=>'1',
        'targetHost'=>'127.0.0.1',
        'option.inbound.length'=>'1',
        'i2cpPort'=>'7654',
        'persistentClientKey'=>'true',
        'option.maxTotalPosts'=>'10',
        'option.i2p.streaming.maxConnsPerDay'=>'100',
        'option.i2p.streaming.maxTotalConnsPerMinute'=>'25',
        'option.i2p.streaming.maxConnsPerMinute'=>'15',
        'name'=>'jruby-tunnel',
        'option.i2p.streaming.maxConcurrentStreams'=>'20',
        'privKeyFile'=>'kake.dat',
        'listenPort'=>'8000'
      }
      merged = dfl.merge(hash)
      merged.keys.each { |k| props[k.to_s] = merged[k].to_s }
      props
    end
  end
end
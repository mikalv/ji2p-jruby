require 'digest/sha1'

module Ji2p
  module Control
    autoload :ClientManager, File.expand_path('control/client_manager.rb', __dir__)
    autoload :Dest, File.expand_path('control/dest.rb', __dir__)
    autoload :Keypair, File.expand_path('control/keypair.rb', __dir__)
    autoload :TunnelManager, File.expand_path('control/tunnel_manager.rb', __dir__)

    def self.unique_id
      Digest::SHA1.hexdigest([Time.now, rand].join)
    end
  end
end
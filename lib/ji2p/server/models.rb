require 'active_record'

module Ji2p::Server
  module Models
    autoload :BaseRecord, File.expand_path('models/base_record.rb', __dir__)
    autoload :Keypair, File.expand_path('models/keypair.rb', __dir__)
    autoload :Tunnel, File.expand_path('models/tunnel.rb', __dir__)
  end
end
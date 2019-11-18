module Ji2p::Control
  class ClientManager
    java_import 'net.i2p.client.I2PClient'
    java_import 'net.i2p.client.I2PClientFactory'

    def self.listClients
      context.clientManager.listClients.to_a
    end

    def self.context
      RouterContext.getCurrentContext
    end
  end
end
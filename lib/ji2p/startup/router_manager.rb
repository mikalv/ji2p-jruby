require 'java'

module Ji2p::Startup
  class RouterManager
    @@router = nil
    include_package 'net.i2p.router'

    def self.start_router!
      @@router = RouterLaunch.main ARGV if @@router.nil?
    end

    def self.router_context
      RouterContext.getCurrentContext
    end

    def self.get_leases
      ctx = RouterManager.router_context
      ctx.netDb.get_leases.to_a
    end
  end
end
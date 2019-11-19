require 'fileutils'

module Ji2p
  module Startup
    class ClientApplication
      java_import 'net.i2p.I2PAppContext'

      def initialize name
        @name = name
        @ctx = Java::NetI2p::I2PAppContext.getGlobalContext
        FileUtils.mkdir_p plugin_path unless File.exists? plugin_path
      end

      def plugin_path
        @proot_path ||= File.expand_path("plugins/#{@name}", @ctx.getAppDir.getAbsolutePath)
      end
    end

  end
end
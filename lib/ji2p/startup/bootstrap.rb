require 'java'

module Ji2p::Startup
  java_import java.lang.ClassLoader
  java_import java.lang.System

  class Bootstrap
    def initialize defaults={'i2p.dir.config' => TMPDIR}
      @defaults = defaults
    end

    def set_system_property key, value
      System.setProperty key.to_s, value.to_s
    end

    def get_system_property value
      System.getProperty[value.to_s]
    end

    def load_jars
      java_import java.lang.Thread
      java_import java.net.URL
      cl = Thread.currentThread.getContextClassLoader
      dirname = System.getProperties['i2p.dir.base']
      Dir["#{dirname}/lib/**.jar"].each do |jar|
        u = Java::JavaNet::URL.new "file://#{jar}"
        cl.addURL u
      end
    end

    def i2p_loaded?
      java_import java.lang.Thread
      cl = Thread.currentThread.getContextClassLoader
      cl.getURLs.select { |item| item.to_s.include? 'i2p.jar' }.size > 0
    end

    def check_and_set_props!
      if System.getProperties['i2p.dir.base'].nil?
        unless ENV['I2PDIR'].nil?
          System.setProperty 'i2p.dir.base', ENV['I2PDIR'].to_s
        else
          raise ArgumentError, 'The system property i2p.dir.base is missing!', caller if @defaults['i2p.dir.base'].nil?
        end
      end
      if System.getProperties['i2p.dir.config'].nil?
        raise ArgumentError, 'The system property i2p.dir.config is missing!', caller if @defaults['i2p.dir.config'].nil?
        System.setProperty 'i2p.dir.config', @defaults['i2p.dir.config']
      end
      System.setProperty 'java.awt.headless', 'true' if System.getProperties['java.awt.headless'].nil?
      System.setProperty 'java.library.path', "#{System.getProperties['i2p.dir.base']}/lib" if System.getProperties['java.library.path'].nil?
    end

    def boot!
      check_and_set_props!
      load_jars unless i2p_loaded?
      RouterManager.start_router!
      RouterManager.router_context
    end
  end
end
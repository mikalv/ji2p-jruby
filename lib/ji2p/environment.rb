require 'pathname'

module Ji2p
  module Environment
    extend self
    JI2P_HOME = ::File.expand_path(::File.join('..','..'), __dir__) unless defined? JI2P_HOME

    BUNDLE_DIR = ::File.join(JI2P_HOME, "vendor", "bundle") unless defined? BUNDLE_DIR
    GEMFILE_PATH = ::File.join(JI2P_HOME, "Gemfile") unless defined? GEMFILE_PATH
    LOCAL_GEM_PATH = ::File.join(JI2P_HOME, 'vendor', 'local_gems') unless defined? LOCAL_GEM_PATH
    CACHE_PATH = ::File.join(JI2P_HOME, "vendor", "cache") unless defined? CACHE_PATH
    LOCKFILE = Pathname.new(::File.join(JI2P_HOME, "Gemfile.lock")) unless defined? LOCKFILE
    GEMFILE = Pathname.new(::File.join(JI2P_HOME, "Gemfile")) unless defined? GEMFILE

    def gem_ruby_version
      RbConfig::CONFIG["ruby_version"]
    end

    def ruby_abi_version
      RUBY_VERSION[/(\d+\.\d+)(\.\d+)*/, 1]
    end

    def ruby_engine
      RUBY_ENGINE
    end

    def ji2p_gem_home
      ::File.join(BUNDLE_DIR, ruby_engine, gem_ruby_version)
    end

    def vendor_path(path)
      return ::File.join(JI2P_HOME, "vendor", path)
    end
  end
end
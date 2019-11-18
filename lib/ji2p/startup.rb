module Ji2p
  module Startup
    autoload :Bootstrap, File.expand_path('startup/bootstrap.rb', __dir__)
    autoload :RouterManager, File.expand_path('startup/router_manager.rb', __dir__)

    TMPDIR = File.expand_path('../../tmp', __dir__) unless defined? TMPDIR

    def self.tmp_dir
      TMPDIR
    end
  end
end
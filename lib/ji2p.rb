require 'active_support/dependencies'
require 'logger'

module Ji2p
  require_relative 'ji2p/version.rb'
  autoload :Cluster, File.expand_path('ji2p/cluster.rb', __dir__)
  autoload :Control, File.expand_path('ji2p/control.rb', __dir__)
  autoload :Server,  File.expand_path('ji2p/server.rb', __dir__)
  autoload :Startup, File.expand_path('ji2p/startup.rb', __dir__)
  ActiveSupport::Dependencies.autoload_paths << __dir__
  Dir.glob('**/').each do |dir|
    ActiveSupport::Dependencies.autoload_paths << File.expand_path(dir, __dir__)
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

end
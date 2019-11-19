#require 'active_support'
#require 'active_support/core_ext'
#require 'active_support/dependencies'
require 'logger'
require 'java'
$CLASSPATH << "file:///#{File.expand_path(File.join(__dir__, '..', 'config'))}/"

require 'ji2p/environment.rb'

module Ji2p
  require_relative 'ji2p/version.rb'
  autoload :Cluster, File.expand_path('ji2p/cluster.rb', __dir__)
  autoload :Control, File.expand_path('ji2p/control.rb', __dir__)
  autoload :Server,  File.expand_path('ji2p/server.rb', __dir__)
  autoload :Startup, File.expand_path('ji2p/startup.rb', __dir__)
  #ActiveSupport::Dependencies.autoload_paths << __dir__
  #Dir.glob('**/').each do |dir|
  #  ActiveSupport::Dependencies.autoload_paths << File.expand_path(dir, __dir__)
  #end

  # https://github.com/jruby/jruby/wiki/RedBridge
  java_import 'java.lang.System'
  System.setProperty("org.jruby.embed.localcontext.scope", "singleton") # concurrent, threadsafe, etc.

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.disable_crypto_restriction
    # java.lang.Class.for_name('javax.crypto.JceSecurity').get_declared_field('isRestricted').tap{|f| f.accessible = true; f.set nil, false}
    security_class = java.lang.Class.for_name('javax.crypto.JceSecurity')
    restricted_field = security_class.get_declared_field('isRestricted')
    restricted_field.accessible = true
    restricted_field.set nil, false
  end

end
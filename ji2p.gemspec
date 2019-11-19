lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'ji2p'

i2p_version = '0.9.43'

Gem::Specification.new do |s|
  s.name        = 'ji2p'
  s.version     = Ji2p::VERSION
  s.date        = Date.today.to_s
  s.summary     = 'JRuby interface for I2P'
  s.description = 'JRuby interface for I2P'
  s.authors     = ['Mikal Villa']
  s.email       = 'mikalv@mikalv.net'
  #s.files       = Dir['lib/**/*.rb'] + Dir['bin/**'] + Dir['lib/**/*.jar']
  s.homepage    = 'https://github.com/mikalv/ji2p'
  s.license     = 'Apache-2.0'
  s.metadata['allowed_push_host'] = 'https://rubygems.org'
  s.platform    = Gem::Platform.local #Gem::Platform.new %w[jruby java universal-java-9 universal-java-10 universal-java-11]
  s.post_install_message = "Thanks for installing!"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  s.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.bindir        = 'bin'
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  # Runtime dependencies
  s.add_runtime_dependency 'bundler', '~> 2.0'
  s.add_runtime_dependency 'activesupport', '>= 4.1.11'
  s.add_runtime_dependency 'httparty', '>= 0.10.0'
  s.add_runtime_dependency 'activerecord', '>= 3.0.18'
  s.add_runtime_dependency 'activerecord-jdbc-adapter', '~> 0'
  s.add_runtime_dependency 'activerecord-jdbcsqlite3-adapter', '~> 0'
  s.add_runtime_dependency 'sinatra', '~> 2.0.7'
  s.add_runtime_dependency 'dbi', '~> 0'
  s.add_runtime_dependency 'dbd-jdbc', '~> 0'
  s.add_runtime_dependency 'puma', '~> 4.3'
  s.add_runtime_dependency 'jruby-rack', '~> 0'
  s.add_runtime_dependency 'rack', '~> 2.0'
  s.add_runtime_dependency 'jar-dependencies', '~> 0'
  s.add_runtime_dependency 'rake', '~> 0'
  s.add_runtime_dependency 'warbler', '~> 0'
  #s.add_runtime_dependency 'activerecord-jdbcpostgresql-adapter', '~> 0'
  #s.add_runtime_dependency 'ed25519', '~> 1.2.4'

  # JARs
  s.requirements << "jar net.i2p.client, streaming, #{i2p_version}"
  s.requirements << "jar net.i2p.client, mstreaming, #{i2p_version}"
  s.requirements << "jar net.i2p, i2p, #{i2p_version}"
  s.requirements << "jar net.i2p, router, #{i2p_version}"
  # jruby -rjars/installer -e 'Jars::Installer.vendor_jars!'

  # Development dependencies
  s.add_development_dependency 'awesome_print', '~> 0'
  s.add_development_dependency 'rspec', '~> 0'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'irbtools', '~> 3.0'
  s.add_development_dependency 'ruby-maven', '~> 3.3'
end

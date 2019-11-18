lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'date'
require 'ji2p'

Gem::Specification.new do |s|
  s.name        = 'ji2p'
  s.version     = Ji2p::VERSION
  s.date        = Date.today.to_s
  s.summary     = 'JRuby interface for I2P'
  s.description = 'JRuby interface for I2P'
  s.authors     = ['Mikal Villa']
  s.email       = 'mikalv@mikalv.net'
  s.files       = Dir['lib/**/*'] + Dir['bin/**']
  s.homepage    = 'https://github.com/mikalv/ji2p'
  s.license     = 'Apache-2.0'
  s.metadata['allowed_push_host'] = 'https://rubygems.org'
  s.platform = Gem::Platform.new %w[jruby]
  # Runtime dependencies
  s.add_runtime_dependency 'activesupport', '>= 4.1.11'
  s.add_runtime_dependency 'httparty', '>= 0.10.0'
  s.add_runtime_dependency 'activerecord', '>= 3.0.18'
  s.add_runtime_dependency 'activerecord-jdbc-adapter', '~> 0'
  s.add_runtime_dependency 'activerecord-jdbcsqlite3-adapter', '~> 0'
  s.add_runtime_dependency 'dbi', '~> 0'
  s.add_runtime_dependency 'dbd-jdbc', '~> 0'
  s.add_runtime_dependency 'jbundler', '~> 0'
  s.add_runtime_dependency 'ed25519', '~> 0'
  # Development dependencies
  s.add_development_dependency 'awesome_print', '~> 0'
  s.add_development_dependency 'rake', '~> 0'
  s.add_development_dependency 'rspec', '~> 0'
  s.add_development_dependency 'pry', '~> 0'
  s.add_development_dependency 'sinatra', '~> 0'
  s.add_development_dependency 'sinatra-contrib', '~> 0'
  s.add_development_dependency 'irbtools', '~> 0'
end
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('Gemfile', __dir__)
require 'bundler/setup'
lib = File.expand_path('lib', __dir__)
$:.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'ji2p'

namespace :server do
  namespace :db do
    desc 'Create a database for private keys'
    task :create do
    end
    desc 'Delete the private key database'
    task :drop do
    end
  end
  namespace :rack do
    desc 'Read config.ru and runs a rack server based upon the config'
    task :start do
    end
  end
  namespace :dbg do
    desc 'Context aware IRB'
    task :console do
    end
  end
end

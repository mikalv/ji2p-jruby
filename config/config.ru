use Rack::Reloader, 1

require File.expand_path('../lib/ji2p.rb', __dir__)
require File.expand_path('../lib/ji2p/startup/sinatra_app.rb', __dir__)

run Ji2p::Startup::SinatraApp.new


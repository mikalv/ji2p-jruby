module Ji2p
  module Server
    autoload :Api, File.expand_path('server/api.rb', __dir__)
    autoload :Database, File.expand_path('server/database.rb', __dir__)
    autoload :HTTP, File.expand_path('server/http.rb', __dir__)
    autoload :HttpServer, File.expand_path('server/http_server.rb', __dir__)
    autoload :Launcher, File.expand_path('server/launcher.rb', __dir__)
    autoload :Models, File.expand_path('server/models.rb', __dir__)
  end
end
module Ji2p
  module Server
    autoload :Api, File.expand_path('server/api.rb', __dir__)
    autoload :Database, File.expand_path('server/database.rb', __dir__)
  end
end
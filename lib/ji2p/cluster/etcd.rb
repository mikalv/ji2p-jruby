module Ji2p::Cluster
  module Etcd
    autoload :Version3, File.expand_path('etcd/version3.rb', __dir__)
  end
end
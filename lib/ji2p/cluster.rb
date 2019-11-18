module Ji2p
  module Cluster
    autoload :Etcd, File.expand_path('cluster/etcd.rb', __dir__)
    autoload :Kubernetes, File.expand_path('cluster/kubernetes.rb', __dir__)
  end
end

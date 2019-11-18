module Ji2p::Cluster
  module Kubernetes
    autoload :KubeApi, File.expand_path('kubernetes/kube_api.rb', __dir__)
  end
end
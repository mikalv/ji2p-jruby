require 'active_record'

module Ji2p::Server::Models
  class BaseRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
require 'active_record'
require 'base64'

module Ji2p::Server::Models
  Ji2p::Control::Keypair.class_eval do
    def to_activerecord
      row = Ji2p::Server::Models::Keypair.new
      row.destination = @dest.base64
      row.base32 = @dest.base32
      row.private_key_data = Base64.encode64(@data)
      row
    end

    private

    def write_dummy_stream obj
      s = StringIO.new
      obj.writeBytes(s.to_outputstream)
      Base64.encode64 s.string
    end
  end
  class Keypair < BaseRecord

    def pk_data
      Base64.decode64(private_key_data)
    end

    def getKeypairInstance
      Ji2p::Control::Keypair.load_from_stream! StringIO.new(pk_data)
    end
  end
end
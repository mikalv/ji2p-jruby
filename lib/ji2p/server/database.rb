require 'active_record'

module Ji2p::Server
  module Database
    @@connections = Hash.new
    @@default_connection = nil

    def self.connect! db=':memory:', db_type='sqlite3'
      conn = ActiveRecord::Base.establish_connection(database: db, adapter: db_type)
      key = "#{db}/#{db_type}/#{Ji2p::Control.unique_id.to_s}"
      @@connections[key] = conn
      @@default_connection = conn if @@default_connection.nil?
      define_state_schema!
      conn
    end

    def self.connect_with_local_path! name
      java_import 'net.i2p.I2PAppContext'
      ctx = Java::NetI2p::I2PAppContext.getGlobalContext
      path = File.join ctx.getConfigDir.toString, name
      connect! path
    end

    def self.flush
      @@default_connection.flush
    end

    def self.default
      @@default_connection
    end

    def self.is_connected?
      get_connections.size > 0
    end

    def self.get_connections
      @@connections
    end

    def self.define_state_schema! b_force=false
      ActiveRecord::Schema.define do
        create_table :keypairs, force: b_force do |t|
          t.string   :strid
          t.string   :name
          t.text     :destination
          t.string   :base32
          t.text     :private_key_data
          t.json     :metadata
          t.timestamps
        end unless ActiveRecord::Base.connection.table_exists? 'keypairs' or b_force
        create_table :tunnels, force: b_force do |t|
          t.string     :name
          t.text       :description
          t.json       :metadata
          t.references :keypair
          t.string     :tunnel_type
          t.integer    :listen_port
          t.integer    :target_port
          t.string     :listen_interface
          t.string     :target_host
          t.timestamps
        end unless ActiveRecord::Base.connection.table_exists? 'tunnels' or b_force
      end
    end
  end
end
require "ostruct"
require "securerandom"

module GenServer
  class << self
    def call(pid, method, *args)
      entry = fetch_entry(pid)
      value, state = entry.module.send(method, entry.state, *args)
      entry.state = state
      update_entry(pid, entry)
      value
    end

    def cast(pid, method, *args)
      entry = fetch_entry(pid)
      entry.state = entry.module.send(method, entry.state, *args)
      update_entry(pid, entry)
      nil
    end

    def start_link(mod, *args)
      state = mod.init(*args)
      add_entry(mod, state)
    end

    def terminate(pid)
      remove_entry(pid)
    end

    private

    def add_entry(mod, state)
      SecureRandom.uuid.tap do |uuid|
        entries[uuid] = OpenStruct.new(
          :module => mod,
          :state => state
        )
      end
    end

    def entries
      @entries ||= {}
    end

    def fetch_entry(pid)
      entries[pid]
    end

    def remove_entry(pid)
      entries.delete(pid)
    end

    def update_entry(pid, entry)
      entries[pid] = entry
    end
  end
end
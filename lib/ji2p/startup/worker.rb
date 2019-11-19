module Ji2p
  module Startup
    class Worker
      def self.start(num_threads:, queue_size:)
        queue = SizedQueue.new(queue_size)
        worker = new(num_threads: num_threads, queue: queue)
        worker.spawn_threads
        worker
      end

      def initialize(num_threads:, queue:)
        @num_threads = num_threads
        @queue = queue
        @threads = []
      end

      attr_reader :num_threads, :threads
      private :threads

      def spawn_threads
        num_threads.times do
          threads << Thread.new do
            while running? || actions?
              action_proc, action_payload = wait_for_action
              action_proc.call(action_payload) if action_proc
            end
          end
        end
      end

      def enqueue(action, payload)
        queue.push([action, payload])
      end

      def stop
        queue.close
        threads.each(&:exit)
        threads.clear
        true
      end

      private

      attr_reader :queue, :threads

      def actions?
        !queue.empty?
      end

      def running?
        !queue.closed?
      end

      def dequeue_action
        queue.pop(true)
      end

      def wait_for_action
        queue.pop(false)
      end
    end
  end
end
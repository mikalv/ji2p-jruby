require 'thread'

module Ji2p
  module Utils
    class BlockingQueue
      attr_reader :queue, :mutex, :cv

      def initialize
        @queue = Array.new
        @mutex = Mutex.new
        @cv    = ConditionVariable.new
      end

      def push(ele)
        @mutex.synchronize do
          @queue.push ele
          @cv.signal
        end
      end

      def pop
        @mutex.synchronize do
          while @queue.empty?
            @cv.wait(@mutex)
          end

          @queue.pop
        end
      end
    end
  end
end
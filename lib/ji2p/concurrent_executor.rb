module Ji2p
  module ConcurrentExecutor
    class Error < StandardError
      def initialize(exceptions)
        @exceptions = exceptions
        super
      end

      def message
        @exceptions.map { | e | e.message }.join "\n"
      end

      def backtrace
        traces = @exceptions.map { |e| e.backtrace }
        ["ConcurrentExecutor::Error START", traces, "END"].flatten
      end
    end

    class Future
      def initialize(pool: nil)
        @pool = pool || Concurrent::FixedThreadPool.new(20)
        @exceptions = Concurrent::Array.new
      end

      # Sample Usage
      # executor = ConcurrentExecutor::Future.new(pool: pool)
      # executor.execute(carriers) do | carrier |
      #   ...
      # end
      #
      # values = executor.resolve

      def execute array, &block
        @futures = array.map do | element |
          Concurrent::Future.execute({ executor: @pool }) do
            yield(element)
          end.rescue do | exception |
            @exceptions << exception
          end
        end

        self
      end

      def resolve
        values = @futures.map(&:value)

        if @exceptions.length > 0
          raise ConcurrentExecutor::Error.new(@exceptions)
        end

        values
      end
    end
  end
end
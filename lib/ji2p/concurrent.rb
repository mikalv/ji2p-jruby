require 'concurrent'

module Ji2p
  module Concurrent
    java_import java.util.concurrent

    def self.getThreadPool
      @service ||= Executors.new_fixed_thread_pool(10)

      # shutdown our ExecutorService when someone kills us
      Kernel.trap('SIGINT') { service.shutdown }

    end


    def self.getSimpleThredPool
      @pool ||= Concurrent::ThreadPoolExecutor.new(
        min_threads: 3, # create up to 3 threads before queueing tasks
        max_threads: 10, # create at most 10 threads
        max_queue: 100, # at most 100 jobs waiting in the queue
    )
    end
  end
end

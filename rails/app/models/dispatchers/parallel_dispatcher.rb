# Dispatches requests in parallel
#
# Uses the serial dispatcher for the regular dispatching, but overrides the dispatch method
# for sweet speed.
class Dispatchers::ParallelDispatcher < Dispatchers::SerialDispatcher
  include Dispatchers::ParallelDispatcherMixin
end

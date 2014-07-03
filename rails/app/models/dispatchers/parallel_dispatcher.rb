# Dispatches requests in parallel
#
# Uses the serial dispatcher for the regular dispatching, but overrides the dispatch method
# for sweet speed.
class Dispatchers::ParallelDispatcher < Dispatchers::SerialDispatcher

  def dispatch( kittens , friends )
    kittens = Parallel.map( kittens , :in_threads => 8 ) do |kitten|
      dispatch_kitten kitten
    end
    friends = Parallel.map( friends , :in_threads => 32 ) do |friend|
      dispatch_friend friend
    end

    kittens + friends
  end

end

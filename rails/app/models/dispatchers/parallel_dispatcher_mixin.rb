# Mixing which implements dispatch so requests are sent in parallel.
#
# In the current implementation, the kittens and the friends are contacted in series.
# This may change in the future.
module Dispatchers::ParallelDispatcherMixin

  def dispatch( kittens , friends )
    kittens_result = Parallel.map( kittens , :in_threads => 8 ) do |kitten|
      dispatch_kitten kitten
    end
    friends_result = Parallel.map( friends , :in_threads => 32 ) do |friend|
      dispatch_friend friend
    end

    kittens_result + friends_result
  end

end

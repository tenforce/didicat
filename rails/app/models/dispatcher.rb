# = The Dispatcher
#
# A dispatcher sends the requests to the various Friend and Kitten
# objects.  The Friends and Kittens are parsed through the filter
# first, but the actual sending of the request is handled by a
# Dispatcher.
#
# The Dispatcher can thus decide how to send the requests, be it by
# a parallel process, or by sending the request in series.
#
# For handling this, a Dispatcher receives the Friends and the
# Kittens in the dispatch method and it returns once all calls are
# finished with a hash containing the "kittens" keyword (containing
# an array of the responses for the kittens) and a "friends" keyword
# (containing an array of the responses for the friends).
#
# == Standard implementation
#
# A default implementation for the dispatcher sends the requests to
# each of the nodes in series.
class Dispatcher < ActiveSparql::Simple
  include PluginComponentMixin

  @class_uri = "http://didicat.sem.tf/v0.1/dispatcher"

  # Dispatches the request to the supplied kittens and the supplied
  # both variables contain a list of contact-points.
  def dispatch( kittens, friends )
    dispatch_kittens( kittens ) + dispatch_friends( friends )
  end

  # Dispatches the request to the kittens.
  def dispatch_kittens( kittens )
    kittens.collect { |kitten| dispatch_kitten kitten }
  end

  # Dispatches the request to a single kitten.
  def dispatch_kitten( kitten )
    raise "Dispatcher #{self.class.to_s} should implement dispatch_kitten, dispatch_kittens or dispatch."
  end

  # Dispatches the request to the friends.
  def dispatch_friends( friends )
    friends.collect { |friend| dispatch_friend friend }
  end

  # Dispatches the request to a single friend.
  def dispatch_friend( friend )
    raise "Dispatcher #{self.class.to_s} should implement dispatch_friend, dispatch_friends or dispatch."
  end
end

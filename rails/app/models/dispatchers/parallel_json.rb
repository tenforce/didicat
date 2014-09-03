# Dispatches JSON requests in parallel
#
# Sends the requests with a requested JSON request format and parses the request
# format.  Assumes requests are GET requests.
class Dispatchers::ParallelJson < Dispatchers::SerialDispatcher
  include Dispatchers::ParallelDispatcherMixin
  include HTTParty
  format :json

  def url_for( node )
    "#{node.url}#{plugin.path}"
  end

  def dispatch_friend( friend )
    get url_for( friend )
  end

  def dispatch_kitten( kitten )
    get url_for( kitten )
  end

end

# Dispatches EDCAT JSON requests in parallel
#
# The requests for each node are sent assuming the nodes are the base path
# for EDCAT instances.
class Dispatchers::EdcatDispatcher < Dispatcher
  include Dispatchers::ParallelDispatcherMixin

  # Send the search query to the supplied URL of the resource.
  #
  # Passes on all parameters from the currently active plugin
  # and returns the resulting HTTParty response.  If anything
  # fails in this process, an empty array is returned.
  def get_json( url )
    begin
      HTTParty.get url , query: plugin.request.query_parameters.except("filter_key")
    rescue
      []
    end
  end

  # Dispatches to a friend by forwarding the request without
  # changing much of anything.
  def dispatch_friend( friend )
    path = plugin.request.path
    get_json "#{friend.url}#{path}"
  end

  # Dispatches to a kitten by removing the extra edcat/ which
  # is available both in the request path as in the kitten's
  # url.
  def dispatch_kitten( kitten )
    path = plugin.request.path[6..-1] # strip off edcat/
    get_json "#{kitten.url}#{path}"
  end

end

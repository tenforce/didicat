# Dispatches EDCAT JSON requests in parallel
#
# The requests for each node are sent assuming the nodes are the base path
# for EDCAT instances.
class Dispatchers::EdcatDispatcher < Dispatchers::SerialDispatcher
  include Dispatchers::ParallelDispatcherMixin

  def url_for_kitten( node )
    # strip off edcat/ for the request
    "#{node.url}#{plugin.request.path[6..-1]}"
  end

  def url_for_friend( node )
    "#{node.url}#{plugin.request.path}"
  end

  def get_json( url )
    JSON.parse HTTParty.get( url , { query: plugin.request.query_parameters } ).body
  end

  def dispatch_friend( friend )
    get_json url_for_friend( friend )
  end

  def dispatch_kitten( kitten )
    get_json url_for_kitten( kitten )
  end

end

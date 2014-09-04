# Dispatches EDCAT JSON requests in parallel
#
# The requests for each node are sent assuming the nodes are the base path
# for EDCAT instances.
class Dispatchers::EdcatDispatcher < Dispatcher
  include Dispatchers::ParallelDispatcherMixin

  def url_for_kitten( node )
    # strip off edcat/ for the request
    "#{node.url}#{plugin.request.path[6..-1]}"
  end

  def url_for_friend( node )
    "#{node.url}#{plugin.request.path}"
  end

  def get_json( url )
    HTTParty.get url , query: plugin.request.query_parameters
  end

  def dispatch_friend( friend )
    begin
      get_json url_for_friend( friend )
    rescue
      []
    end
  end

  def dispatch_kitten( kitten )
    begin
      get_json url_for_kitten( kitten )
    rescue
      []
    end
  end

end

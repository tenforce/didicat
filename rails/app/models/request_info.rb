# This object provides easy accessors for information you may need when handling a request
class RequestInfo
  include ActiveModel::Model

  attr_accessor :method
  attr_accessor :path
  attr_accessor :request
  attr_accessor :params

  # Returns the get parameters which were explicitly entered by the user
  # for this request.
  def query_parameters
    request.filtered_env.to_h["action_dispatch.request.query_parameters"]
  end

end

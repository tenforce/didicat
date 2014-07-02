# This object provides easy accessors for information you may need when handling a request
class RequestInfo
  include ActiveModel::Model

  attr_accessor :method
  attr_accessor :path
  attr_accessor :request

end

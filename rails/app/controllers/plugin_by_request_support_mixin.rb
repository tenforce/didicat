# Support for building a RequestInfo object from the current request
# and for finding the Plugin which belongs to this request.
module PluginByRequestSupportMixin

  def request_info
    @request_info ||= RequestInfo.new( :method => request.request_method_symbol,
                                       :path => "/#{params[:path]}",
                                       :request => request )
  end

  def plugin
    Plugin.find_by_request request_info
  end

end

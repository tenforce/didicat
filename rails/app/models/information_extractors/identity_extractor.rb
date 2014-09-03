# = The IdentityExtractor
#
# Returns the complete response, as retrieved by the Dispatcher.
# 
# This is handy if the dispatcher already extracts the required response.
class InformationExtractors::IdentityExtractor < InformationExtractor

  def extract( response )
    response
  end

end

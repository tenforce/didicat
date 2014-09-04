# == JSON extractor
#
# This extractor parses the result as JSON and returns all
# the JSON contents.
#
# It assumes it will receive a string being the body of the response,
# or an object which has a ``body`` property containing the body.
# Responses which couldn't be parsed are returned as an
# empty object.
class InformationExtractors::Json < InformationExtractor

  # This is the response which is returned if the body
  # could not be parsed as JSON.
  def fail_response
    []
  end

  # Extracts JSON from the body.
  def extract( response )
    begin
      if response.class == String
        JSON.parse response
      else
        JSON.parse response.body
      end
    rescue
      fail_response
    end
  end

end

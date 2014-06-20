# = The information Extractor
#
# An information extractor extracts information from a response.
# For the default implementation we expect the extractor to receive
# the body of the response.  The extractor will then convert it to
# json and return that.
#
# == Standard implementation
#
# Extractors are expected to return JSON content by default.  However
# if the plugin uses a combinator which understands something else
# then it is perfectly valid to return a different type of content.
#
# Options for extracting content are possible.  As such, an extractor
# may -- for instance -- parse the title from the requested page and
# return the title as a string (without any special markup).  A
# well-behaving plugin may append all strings and return them to the
# user.
#
#
# == How to build
#
# Add an extractor to the information_extractors folder, ensure it
# inherits from InformationExtractor and define the applicationClass
# in the extractor itself.
class InformationExtractor < ActiveSparql::Simple

  @@class_uri = "http://active-sparql.sem.tf/v0.1#information_extractor"

  # Extracts the information from the response and/or body.  The body
  # provides an easier way of accessing the returned content.
  def extract( response, body )
    raise "#{self.name} should override the extract method."
  end

end

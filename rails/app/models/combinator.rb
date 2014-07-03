# = The combinator
#
# A combinator combines bits of information extracted by multiple
# InformationExtractor s into a single result which may be returned to
# the client.
#
# The combinator works much like a reduce operation.  It starts from a
# base value, and provides an operation to combine it with extra info.
# The base value is specified in the base_value method, which must be
# overridden.
#
# == Standard implementation
#
# We expect the Information Extractors to return JSON by default and
# combine them by placing them all into a list.
#
# The combinator may solve complex problems.  If the combinator works
# together with the Filter, it may help in the efficient querying of
# listings.
#
# == How to build
#
# Add a Combinator to the combinators folder, ensure it inherits from
# Combinator and define the applicationClass in the extractor itself.
#
# Override the combine and the base_value methods and you're ready to
# go.
class Combinator < ActiveSparql::Simple
  include PluginComponentMixin

  @class_uri = "http://didicat.sem.tf/v0.1/combinator"

  # Returns the base_value which is used to combine the first result.
  def base_value
    raise "#{self.class.name} should define a none_value."
  end

  # Combines the first value with the newly extracted information.
  def combine( base, extracted_information )
    raise "#{self.class.name} should override the combine method."
  end

  # Combines all of the results.  If this isn't overridden, an
  # implementation is built based on base_value and combine
  def combine_all( results )
    current = base_value
    results.each { |res| current = combine( current, res ) }
    current
  end

end

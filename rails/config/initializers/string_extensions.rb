class String

  # Converts the string to a URI representation of the string.
  def to_uri
    RDF::URI.new( self )
  end

end

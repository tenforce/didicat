#
# == Search Filter
#
# This filter performs a search and dispatches to each friend and
# which could provide answers to the search.
#
# For both friends and kittens, a search is performed on the catalog
# level.  If any catalogs were returned, the peer is locked and will
# be queried when the filter is executed.
class NodeFilters::EdcatSearch < NodeFilter

  def contact_friend?( request , friend )
    retrieve_nodes request.params
    @friends.include? friend.url
  end

  def contact_kitten?( request , kitten )
    retrieve_nodes request.params
    @kittens.include? kitten.url
  end

  # Send the query to each of our kittens
  # If a kitten responds: keep it
  def responding_kittens( request )
    Kitten.all.select do |kitten|
      filter_node_by_search request, kitten.url
    end
  end

  # Send the query to each of the friends
  # If a friend responds: keep it
  def responding_friends( request )
    Friend.all.select do |friend|
      filter_node_by_search request, "#{friend.url}/edcat"
    end
  end

  # Generates a key for the filter
  def generate_key
    SecureRandom.urlsafe_base64
  end

  def make_filter_key( request )
    key = generate_key
    graph = RDF::Graph.new
    filter_uri = "http://didicat.semte.ch/v0.1/filters/#{key}".to_uri

    # Set the base info
    graph << [ filter_uri , "http://didicat.semte.ch/v0.1/filterKey".to_uri , key ]
    graph << [ filter_uri ,
               "http://didicat.semte.ch/v0.1/filterSpec".to_uri ,
               request.query_parameters_string ]

    # Store each kitten
    responding_kittens( request ).each do |kitten|
      graph << [ filter_uri ,
                 "http://didicat.semte.ch/v0.1/kitten".to_uri ,
                 kitten.url.to_uri ]
    end

    # Store each friend
    responding_friends( request ).each do |friend|
      graph << [ filter_uri ,
                 "http://didicat.semte.ch/v0.1/friend".to_uri ,
                 friend.url.to_uri ]
    end

    # Insert the data
    Db.insert_data( graph , :graph => RDF::URI.new( self.class.object_graph ) )

    # Return the new key
    key
  end

protected

  # Calling this method ensures the cache of kittens and friends to
  # be contacted has been set up correctly.
  def retrieve_nodes( request_params )
    unless request_params[:filter_key]
      @kittens ||= Kitten.all.collect { |k| k.url.to_s }
      @friends ||= Friend.all.collect { |k| k.url.to_s }
    else
      kittens_query = <<QUERY
PREFIX didicat: <http://didicat.semte.ch/v0.1/>
SELECT DISTINCT ?contact_url
WHERE {
  ?filter_instance didicat:filterKey "#{request_params[:filter_key]}";
                   didicat:kitten ?contact_url.
}
QUERY

      friends_query = <<QUERY
PREFIX didicat: <http://didicat.semte.ch/v0.1/>
SELECT DISTINCT ?contact_url
WHERE {
  ?filter_instance didicat:filterKey "#{request_params[:filter_key]}";
                   didicat:friend ?contact_url.
}
QUERY

      @kittens ||= Db.query( kittens_query , self.class.object_graph ).map { |k| k[:contact_url].to_s }
      @friends ||= Db.query( friends_query , self.class.object_graph ).map { |f| f[:contact_url].to_s }
    end
  end

  # Filters a node by sending a search request
  # If the search doesn't return an array or if the array is empty,
  # the filter returns false.
  def filter_node_by_search( request, base_url )
    begin
      url = "#{base_url}/catalogs/search"
      options = { query: request.query_parameters }
      response = JSON.parse HTTParty.get( url , options ).body
      response.class == Array && response.length > 0
    rescue
      false
    end
  end
end

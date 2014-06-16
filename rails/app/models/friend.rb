class Friend < ActiveSparql::Base
  attr_accessor :url
  validates_presence_of :url

  # Indicates that the friend with url URL joined the peer group
  def self.join( url)
    Friend.new( url: url ).save
  end

  # Indicates that the friend with url URL left the peer group
  def self.leave( url )
    Friend.find( url ).destroy
  end

  def self.register_at_peer_cnnctr
    # destroy the current friends
    Friend.all.map &:destroy
    # call the peer_cnnctr and add all current friends
    peer_cnnctr_uri = URI "#{Cfg.peer_cnnctr_url}peer_groups/#{Cfg.peer_cnnctr_peer_group}/peers.json"
    my_cnnctr_info = { "peer[contact_point]" => Cfg.own_contact_point, "peer[shared_contact_url]" => Cfg.shared_contact_url }
    result = Net::HTTP.post_form( peer_cnnctr_uri , my_cnnctr_info )
    json = JSON.parse result.body
    json["peers"].each do |contact_point|
      # add our freshly joined peers
      Friend.new( url: contact_point ).save
    end
  end

protected

  TYPE_URI = 'http://ddcat.edcat.tenforce.com/Friend'.to_uri

  # Override to return a String containing the graph where objects of this
  # kind are stored.
  def self.object_graph
    Cfg.friend_graph
  end

  def self.all_query
<<SPARQL
  SELECT ?url
  WHERE {
    ?url a <#{TYPE_URI}>.
  }
SPARQL
  end

  def self.find_query( url )
<<SPARQL
  SELECT ?url
  WHERE {
    ?url a <#{TYPE_URI}>.
    VALUES ?url {<#{url}>}
  }
SPARQL
  end

  # Enters the triples which define this Friend in the graph.
  def fill_save_graph( graph )
    if persisted?
      fetch_object_triples.each do |statement|
        graph << RDF::Statement(statement.to_hash)
      end
    else
      graph << [url.to_uri, "http://www.w3.org/1999/02/22-rdf-syntax-ns#type".to_uri, TYPE_URI]
    end
  end

  # Fetches the triples which define this Friend in the graph.
  def fetch_object_triples
    Db.query(:friend) do
<<SPARQL
  SELECT ?subject, ?predicate, ?object
  WHERE {
    <#{url}> !<wuk:doesntexist>* ?subject.
    ?subject ?predicate ?object
  }
SPARQL
    end
  end

end

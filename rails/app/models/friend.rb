class Friend < ActiveSparql::Base
  attr_accessor :url
  validates_presence_of :url

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
    ?foo <http://ddcat.edcat.tenforce.com/identifier> "#{id}".
    ?foo !<wuk:doesntexist>* ?subject.
    ?subject ?predicate ?object
  }
SPARQL
    end
  end

end

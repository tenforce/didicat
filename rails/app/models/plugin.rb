class Plugin < ActiveSparql::Base
  attr_accessor :id,:url,:requests
  validates_presence_of :url

  protected

  # Override to return a String containing the graph where objects of this
  # kind are stored.
  def self.object_graph
    Cfg.plugin_graph
  end

  def self.all_query
<<SPARQL
  SELECT ?id ?url
  WHERE {
    ?url a <http://ddcat.tenforce.com/Plugin>.
    ?url <http://ddcat.tenforce.com/identifier> ?id.
  }
SPARQL
  end

  def self.find_query( id )
<<SPARQL
  SELECT "#{id}" as ?id  ?url
  WHERE {
    ?url a <http://ddcat.tenforce.com/Plugin>.
    ?url <http://ddcat.tenforce.com/identifier> "#{id}"
  }
SPARQL
  end

  # Enters the triples which define this graph in the Peer.
  def fill_save_graph( graph )
    if persisted?
      fetch_object_triples.each do |statement|
        graph << RDF::Statement(statement.to_hash)
      end
    else
      graph.load url
      real_url = graph.select{|x| x.object == "http://ddcat.tenforce.com/Plugin".to_uri}.first.subject
      graph << [real_url, "http://ddcat.tenforce.com/identifier".to_uri, id ]
    end
  end

  # Enters the triples which define this graph in the Peer.
  def fetch_object_triples
    Db.query(:plugin) do
<<SPARQL
  SELECT ?subject, ?predicate, ?object
  WHERE {
    ?foo <http://ddcat.tenforce.com/identifier> "#{id}".
    ?foo !<wuk:doesntexist>* ?subject.
    ?subject ?predicate ?object
  }
SPARQL
    end
  end

  # Names of the headers which ought to be forwarded for this request
  def self.required_headers_for_request( request_uri )
    Db.query(:plugin) do
<<SPARQL
  SELECT DISTINCT ?header
  WHERE {
    { <#{request_uri}> <http://ddcat.tenforce.com/header> ?header. }
    UNION
    { ?s <http://ddcat.tenforce.com/globalHeader> ?header. }
  }
SPARQL
    end.map { |r| r[:header].to_s }
  end

  # Retrieves the resource of the request which matches the supplied path
  #
  # Note: we only assume GET verbs for now.
  def self.request_for_path( path )
    result = Db.query(:plugin) do
<<SPARQL
  SELECT DISTINCT ?request
  WHERE {
    ?plugin a <http://ddcat.tenforce.com/Plugin>;
            <http://ddcat.tenforce.com/request> ?request.
    ?request <http://ddcat.tenforce.com/pathRegex> ?regex;
             <http://ddcat.tenforce.com/verb> <http://ddcat.tenforce.com/GET>.
    FILTER regex("#{path}", ?regex)
  }
SPARQL
    end

    raise "Too many paths match request." if result.size > 1

    result.size > 0 && result[0][:request].to_s
  end

  def self.combinator_uri_for_request( request_uri )
    Db.query(:plugin) do
<<SPARQL
  SELECT DISTINCT ?combinator
  WHERE {
    <#{request_uri}> <http://ddcat.tenforce.com/combinator> ?combinator.
  }
SPARQL
    end.first[:combinator].to_s
  end

  def self.combinator_for_request( request_uri )
    Combinator.find_combinator( combinator_uri_for_request( request_uri ) )
  end

end

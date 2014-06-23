class Plugin < ActiveSparql::Simple
  @class_uri = 'http://ddcat.tenforce.com/Plugin'
  pred :regex, ["http://ddcat.tenforce.com/request", "http://ddcat.tenforce.com/pathRegex"]
  pred :verb,  ["http://ddcat.tenforce.com/request", "http://ddcat.tenforce.com/verb"]
  has_one :filter, ["http://ddcat.tenforce.com/filter"], class: :node_filter
  has_one :combinator, "http://ddcat.tenforce.com/combinator"
  has_one :extractor, "http://ddcat.tenforce.com/extractor", class: :information_extractor
  has_one :dispatcher, "http://ddcat.tenforce.com/dispatcher"

  attr_accessor :id,:url,:requests
  validates_presence_of :url

  # Retrieves the plugins from a remote source
  def self.add_remote_plugin( url )
    graph = RDF::Graph.new
    graph.load url
    Db.insert_data graph, graph: object_graph
  end

  # Retrieves the plugin based on the posed request object
  def self.find_by_request( path, method )
    urls = Db.query(:plugin) do
<<SPARQL
  SELECT DISTINCT ?url
  WHERE {
    ?url a <http://ddcat.tenforce.com/Plugin>;
         <http://ddcat.tenforce.com/request> ?request.
    ?request <http://ddcat.tenforce.com/pathRegex> ?regex;
             <http://ddcat.tenforce.com/verb> "#{method.to_s.upcase}".
    FILTER regex("#{path}", ?regex)
  }
SPARQL
    end

    urls.map { |url| Plugin.find url }
  end

protected

  def self.object_graph
    Cfg.plugin_graph
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

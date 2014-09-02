class Plugin < ActiveSparql::Simple
  @class_uri = 'http://didicat.semte.ch/v0.1/Plugin'
  pred :regex, "http://didicat.semte.ch/v0.1/regex"
  pred :verb,  "http://didicat.semte.ch/v0.1/verb"
  has_one :filter, ["http://didicat.semte.ch/v0.1/filter"], class: :node_filter
  has_one :combinator, "http://didicat.semte.ch/v0.1/combinator"
  has_one :extractor, "http://didicat.semte.ch/v0.1/extractor", class: :information_extractor
  has_one :dispatcher, "http://didicat.semte.ch/v0.1/dispatcher"

  attr_accessor :id,:url,:request
  validates_presence_of :url

  # Dispatches the request both to our friends as to our kittens
  def all_dispatch( request )
    prepare_dispatch
    kittens = Kitten.all.select { |kitten| filter.contact_kitten? request, kitten }
    friends = Friend.all.select { |friend| filter.contact_friend? request, friend }
    results = dispatcher.dispatch kittens, friends
    extracted_info = results.collect { |res| extractor.extract( res ) }
    combinator.combine_all extracted_info
  end

  # Dispatches the request only to our kittens
  def kitten_dispatch( request )
    prepare_dispatch
    kittens = Kitten.all.select { |kitten| filter.contact_kitten? request, kitten }
    results = dispatcher.dispatch kittens, []
    extracted_info = results.collect { |res| extractor.extract( res ) }
    combinator.combine_all extracted_info
  end

  # Retrieves the plugins from a remote source
  def self.add_remote_plugin( url )
    graph = RDF::Graph.new
    graph.load url
    Db.insert_data graph, graph: object_graph
  end

  # Retrieves the plugin based on the posed request object
  def self.find_by_request( request_info )
    path = request_info.path
    method = request_info.method
    query_answers = Db.query( object_graph ) do
<<SPARQL
  SELECT DISTINCT ?url
  WHERE {
    ?url a <http://didicat.semte.ch/v0.1/Plugin>;
         <http://didicat.semte.ch/v0.1/regex> ?regex;
         <http://didicat.semte.ch/v0.1/verb> "#{method.to_s.upcase}".
    FILTER regex("#{path}", ?regex)
  }
SPARQL
    end

    plugins = query_answers.map{ |p| p[:url] }.map{ |url| Plugin.find url }

    if plugins.length == 0
      raise "Could not find plugin for #{method.to_s.upcase} #{path}"
    elsif plugins.length > 1
      raise "More than one plugin answers #{method.to_s.upcase} #{path}"
    else
      plugin = plugins.first
      plugin.request = request_info
      plugin
    end

  end

protected

  # Prepares the plugin and its contained elements so they are ready for dispatching
  def prepare_dispatch
    [filter,combinator,extractor,dispatcher].each do |o|
      o.plugin = self
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

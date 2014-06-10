class Db < SPARQL::Client

  def initialize
    super klass[:endpoint]
  end

  def self.query(*args,&block)
    self.new.query(*args, &block)
  end

  # Same as sparql.query but allows for a block to be given which yields the query
  def query( *args )
    # fetch arguments
    if block_given?
      query = yield
      graph = args[0]
    else
      query,graph = args
    end
    graph = translate_graph_from_argument(graph)
    query.gsub! /WHERE/i,"FROM <#{graph.to_s}>\n WHERE" if graph
    super( query )
  end

  # Retrieves the SPARQL_CONFIG variable as read from sparql.yml
  def self.[](arg)
    Cfg[arg]
  end

  def self.method_missing( method, *args, &block )
    self.new.send( method , *args, &block )
  end

private

  def klass
    self.class
  end

  def translate_graph_from_argument( graph )
    if graph.is_a? Symbol
      RDF::URI.new klass["#{graph.to_s}_graph"]
    else
      graph
    end
  end

end

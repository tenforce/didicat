module ActiveSparql
  class Simple < Base

    attr_accessor :url
    @class_uri = "http://active-sparql.sem.tf/v0.1#simple"
    @variables = {}
    @has_one_links = {}

    def self.variables
      @variables ||= {}
    end

    def self.has_one_links
      @has_one_links ||= {}
    end

    def self.load( *args )
      result = super( *args )
      has_one_links.each do |pred,options|
        klass = Kernel.const_get options[:class].to_s.classify
        url = result.send pred
        result.send( "#{pred.to_s}=".to_sym , klass.find( url ) ) if url
      end
      result
    end

    def self.class_uri
      @class_uri
    end

    # Defines a predicate which is used to collect data.
    # eg: pred :name, "http://xmlns.com/foaf/0.1/nick"
    #     pred :author_name, ["http://something/author", "http://something/name"]
    def self.pred( sym, predicates )
      # accept one or multiple predicates
      unless predicates.instance_of? Array
        predicates = [ predicates ]
      end
      # use symbol as variable
      sym = sym.to_sym
      self.variables[sym.to_sym] = predicates.map &:to_uri
      attr_accessor sym.to_sym
    end

    def self.has_one( attr_name, predicates, options={} )
      attr_name = attr_name.to_sym
      options[:class] ||= attr_name.to_sym
      # accept one or multiple predicates
      unless predicates.instance_of? Array
        predicates = [ predicates ]
      end
      # use symbol as variable
      attr_accessor attr_name
      self.has_one_links[attr_name] = { :predicates => predicates.map(&:to_uri) , :class => options[:class] }
    end

    # from Base#object_graph
    def self.object_graph
      Cfg.active_sparql_graph
    end

    # from Base#all_query
    def self.all_query
<<SPARQL
  SELECT DISTINCT ?url #{sparql_pred_variables}
  WHERE {
    { ?url a <#{self.class_uri}>. }
    #{sparql_pred_paths.map{|path| " UNION { #{path} } "}.join("\n")}
  }
SPARQL
    end

    # from Base#find_query
    def self.find_query( url )
<<SPARQL
  SELECT DISTINCT <#{url}> AS ?url ?class #{sparql_pred_variables}
  WHERE {
    { ?url a <http://ddcat.tenforce.com/Plugin>. }
    #{sparql_pred_paths.map{|path| " UNION { #{path} } "}.join("\n")}
    UNION {
      ?url <http://active_sparql.sem.tf/v0.1#applicationClass> ?class.
    }
  }
SPARQL
    end

    # from Base#fill_save_graph
    def fill_save_graph( graph )
      # insert the information from the predicates
      predicate_connection = {[] => url.to_uri}
      klass.variables.each do |keyword, predicates|
        value = self.send keyword
        predicate_connection[predicates] = self.send value if value != nil
      end
      # insert the information from the has_one_links
      klass.has_one_links.each do |keyword, options|
        object = self.send( keyword )
        predicate_connection[predicates] = object.url if object
      end

      predicate_connection.clone.each do |predicates , keyword|
        unless predicates == []
          # ensure anything for the path is ready to be written
          predicates.trailed_walk( include_empty: false ) do |predicates|
            unless predicate_connection.has_key? predicates
              blank_node = RDF::Node.new
              predicate_connection[predicates] = blank_node
              graph << [predicate_connection[predicates[0,-2]] , predicates[-1].to_uri, blank_node]
            end
          end
          # write the final predicate
          butlast_node = predicate_connection[predicates[0,-2]]
          last_node = predicate_connection[predicates]
          graph << [ butlast_node , predicates[-1].to_uri , last_node ]
        end
      end

      # set the class name
      graph << [url.to_uri, "http://www.w3.org/1999/02/22-rdf-syntax-ns#type".to_uri, klass.class_uri.to_uri]
      # set the application class
      graph << [url.to_uri, "http://active_sparql.sem.tf/v0.1#applicationClass".to_uri, klass.to_s ]
    end

    def fetch_object_triples
      Db.query(klass.object_graph) do
<<SPARQL
  SELECT DISTINCT ?subject, ?predicate, ?object
  WHERE {
    <#{url}> !<wuk:doesntexist>* ?subject.
    ?subject ?predicate ?object.
  }
SPARQL
      end
    end

  private

    def self.sparql_pred_variables
      self.variables.keys.map{|k| "?#{k.to_s}" }.join(" ")
    end

    def self.sparql_pred_paths
      self.variables.collect do |k,v|
        "?url " + v.map{|v| "<#{v.to_s}>"}.join(" / ") + " ?#{k.to_s}."
      end
    end

  end
end

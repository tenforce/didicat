module ActiveSparql
  class Base
    include ActiveModel::Model
    attr_accessor :id

    @persisted

    @@config = { :base_uri => "" }

    def initialize(*args)
      @persisted = false
      super(*args)
    end

    # Saves the object to the database
    def save
      self.id = klass.generate_identifier unless persisted? || id
      save_graph = RDF::Graph.new
      fill_save_graph save_graph
      Db.insert_data( save_graph , :graph => klass.object_graph )
      persist!
    end

    def destroy
      save_graph = RDF::Graph.new
      fill_save_graph save_graph
      save_graph.each do |s|
        puts s.inspect
      end
      Db.delete_data( save_graph, :graph => klass.object_graph )
    end

    def uri
      "#{@@config[:base_uri]}#{id}"
    end

    # Loads a stored object from the database
    def self.load( *args )
      object = self.new *args
      object.id = args.first[:id]
      object.persist!
      object
    end

    # Returns all objects of this kind
    def self.all
      result = Db.query( all_query , self.object_graph )
      result.map do |hash|
        self.load hash
      end
    end

    # Returns the object with the supplide identifier
    def self.find( id )
      self.load( Db.query(find_query( id ) , self.object_graph).first )
    end

    # Indicates that this object is persisted.
    def persist!
      @persisted = true
    end

    # Inherited
    def persisted?
      @persisted
    end

    # Returns the class object of the current object
    def klass
      self.class
    end

  protected

    # Override to return a String containing the graph where objects of this
    # kind are stored.
    def self.object_graph
      raise "#{self.to_s}.object_graph should return the graph where the objects of this kind are stored."
    end

    def self.all_query
      raise "#{self.to_s}.all_query should return the SPARQL query which returns all the hashes for all the objects of this type."
    end

    def self.find_query( id )
      raise "#{self.to_s}.find_query(#{id}) should return the SPARQL query which returns the hash for creating the object with type #{self.to_s} and id #{id}."
    end

    # Enters the triples which define this graph in the Peer.
    def fill_save_graph( graph )
      raise "#{self.to_s}.fill_save_graph should fill the supplied graph with the data from the object."
    end

    # Enters the triples which define this graph in the Peer.
    def fill_destroy_graph( graph )
      fill_save_graph( graph )
    end

    # Uses a UUID and the base uri to generate an ID for the supplied object
    def self.generate_identifier
      SecureRandom.urlsafe_base64
    end

  end

end

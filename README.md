didiCAT
=======

didiCAT is a Distributed request combinator and dispatcher.  It offers a unified view on a set of
underlying services.


Topology
--------

didiCAT dispatches requests to peers and children.  Each instance specifies which requests are
supported and how they are handled.

A didiCAT instance lives in a group of peer didiCAT instances (known as friends).  Each instance
governs a set of services over which it offers an abstract interface.  didiCAT instances find their
friends by contacting a peer_cnnctr at a previously known location.  As each didiCAT instance
governs a set of services, the instance needs to be configured.  The implementation specifying how
services are queried and combined is done in Ruby.  The specification of which handlers to use for
the request is done through triples (Turtle and RDF/XML are supported).


Using didiCAT
-------------

didiCAT uses the `peer_cnnctr` service to discover instances.  It has a Rails JSON backend and an
ember-cli frontend.  The backend uses sqlite and Virtuoso as a store.

### Necessary services

didiCAT uses a `peer_cnnctr`, Ruby on Rails, an Sqlite database and Virtuoso.

In order to use didiCAT, you need to have a didiCAT instance and a `peer_cnnctr`.  The `peer_cnnctr`
allows didiCAT instances to discover their peers.  You can find the `peer_cnnctr` at
`tenforce/peer_cnnctr`.

didiCAT stores its configuration, peers and children in a database.  Both a SPARQL1.1 endpoint and a
Relation database is used.  We used Virtuoso 7.1 as SPARQL endpoint, but other SPARQL1.1 compliant
stores should work also.  The SPARQL endpoint is configured in
`rails/config/didicat/sparql.yaml`. For a relational database Sqlite is used, but that too can be
swapped out for a different database in typical Rails fashion, see `rails/config/db.yaml`.


### Configuring didiCAT

The implementation of didiCAT's operations is handled by plugins.  A plugin configuration is a graph
which describes (and possibly further configures) a set of plugins.  Examples of these configurations
can be found in the `examples` folder.

Each configuration specifies the following:

- A uri for the new plugin, of type Plugin.
- A regex for the path to operate on.
- The filter for queries of this path, which is a selector which allows you to query only portions of the peers and children.
- The dispatcher, which specifies which specific requests should be sent to peers and children.
- The extractor, which extracts the required contents from the requests of the peers and children.
- The combinator, which combines the results of the children and peers to what the user would expect.

This architecture allows for reuse between the components.  Once a JSON list combinator is built once, it can be reused across installations.

The implementation of each of these objects is done through classes.  Each of the components has a base class:

- Filters extend `rails/app/models/node_filter.rb`
- Dispatchers extend `rails/app/models/dispatcher.rb`
- Extractors extend `rails/app/models/information_extractor.rb`
- Combinators extend `rails/app/models/combinator.rb`

The extentions are placed in their relevant subfolder.  Documentation regarding the intended operation can be found in the ruby files (or through RDoc).

# = The Node Filter
#
# A NodeFilter indicates whether or not a specific node should be
# contacted for the current request.  It has a separate implementation
# for a kitten and for a friend.
#
# The kittens are the nodes which are governed by the current didicat
# instance, the friends are the peers of the current installation.
#
#
# == Standard implementation
#
# A default implementation would be to allow every Kitten and every
# Friend to handle the request.  Although this would be very
# inefficient if all nodes contain similar information, it could be a
# good basis.  This is implemented in NodeFilters::All .
#
#
# == Intended use
#
# The aimed use for the node filter is to intelligently select the
# nodes which may answer a request.  In terms of EDCAT this could be
# done by querying the themes of the request and selecting the node
# if the request handles the specified theme.
#
#
# == How to build
#
# Add a node filter to the node_filters folder, ensure it inherits
# from NodeFilter and define the applicationClass in the specification
# of the plugin.
class NodeFilter < ActiveSparql::Simple
  include PluginComponentMixin

  @class_uri = "http://didicat.semte.ch/v0.1/node_filter"

  # Retrun true if we should contact friend when handling request.
  #
  # Request is the didicat-specific request object.
  def contact_friend?( request, friend )
    raise "#{self.class.to_s} should override contact_friend?"
  end

  # Return true if we should contact kitten when handling request.
  #
  # Request is the didicat-specific request object.
  def contact_kitten?( request, kitten )
    raise "#{self.class.to_s} should override contact_kitten?"
  end

  # You can filter for a specific filter-request.  The filter will
  # need to specify what options to supply to the request-filter.
  #
  # In order to build the filter, a request will be made to the path
  # where the plugin which incorporates this filter resides (or
  # deeper).  All info for the request should be supplied with
  # keywords or the path in this request.
  #
  # If a requester chooses to make use of this functionality, the
  # request which uses the supplied filter will be supplied using the
  # :filter_key parameter.
  def make_filter_key( request )
    return ""
  end

end

# Handy mixing which supports the components of a Plugin.
#
# The components are the user-configurable components of which a
# plugin consists.
module PluginComponentMixin

  def initialize( plugin )
    @plugin = plugin
  end

  # Retrieves the plugin.
  #
  # Each of the components of the plugin should be available when this
  # component is ran (but *not* necessarily when the component is
  # built).
  def plugin
    @plugin
  end

end

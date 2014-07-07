`import Ember from 'ember'`

PluginsRoute = Ember.Route.extend
  model: ->
    @store.find 'plugin'

`export default PluginsRoute`

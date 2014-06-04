PeersRoute = Ember.Route.extend
  model: ->
    @store.find 'peer'

`export default PeersRoute;`

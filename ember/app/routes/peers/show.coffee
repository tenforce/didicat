PeersShowRoute = Ember.Route.extend
  model: (params) ->
    @store.find('peer', params.id)

`export default PeersShowRoute;`

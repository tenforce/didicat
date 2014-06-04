FriendsShowRoute = Ember.Route.extend
  model: (params) ->
    @store.find('friend', params.id)

`export default FriendsShowRoute;`

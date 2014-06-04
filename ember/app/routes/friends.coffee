FriendsRoute = Ember.Route.extend
  model: ->
    @store.find 'friend'

`export default FriendsRoute;`

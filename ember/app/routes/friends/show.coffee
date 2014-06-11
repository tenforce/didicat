FriendsShowRoute = Ember.Route.extend
  model: (params) ->
    @store.find 'friend', decodeURIComponent params.friend_url
    # @store.find 'friend', params.id
  serialize: (model) ->
    friend_url: encodeURIComponent model.get 'url'

`export default FriendsShowRoute;`

`import Ember from "ember"`

FriendsRoute = Ember.Route.extend
  model: ->
    @store.find 'friend'

`export default FriendsRoute`

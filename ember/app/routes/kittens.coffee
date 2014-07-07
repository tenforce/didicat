`import Ember from 'ember'`

KittensRoute = Ember.Route.extend
  model: ->
    @store.find 'kitten'

`export default KittensRoute`

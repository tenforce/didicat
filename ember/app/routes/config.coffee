`import Ember from 'ember'`

ConfigRoute = Ember.Route.extend
  model: ->
    Ember.$.getJSON '/api/config'

`export default ConfigRoute`

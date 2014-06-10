NewPluginComponent = Ember.Component.extend
  classNames: 'plugin-entry'
  actions:
    create: ->
      @sendAction 'action', @get 'url'
      @set 'url', ''
  url: ''

`export default NewPluginComponent;`

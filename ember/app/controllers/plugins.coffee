PluginsController = Ember.ArrayController.extend
  actions:
    createPlugin: (url) ->
      Ember.$.ajax(
        method: 'POST'
        url: '/api/plugins'
        data: plugin: url: url
      ).then =>
        @store.find 'plugin'

`export default PluginsController;`

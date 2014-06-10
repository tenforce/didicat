`import startApp from 'didicat/tests/helpers/start-app';`

App = null
server = null

plugins = [ {
  id: 'http://plugins.com/lippy'
  url: 'http://plugins.com/lippy'
}, {
  id: 'http://plugins.com/laura'
  url: 'http://plugins.com/laura'
}, {
  id: 'http://plugins.com/poppo'
  url: 'http://plugins.com/poppo'
} ]

module 'Integration - Plugins page',
  setup: ->
    App = startApp()

    server = new Pretender ->
      @get '/api/plugins', (request) ->
        [200, {'Content-Type': 'application/json'}, JSON.stringify(plugins: plugins)]
      @get '/api/plugins/:id', (request) ->
        plugin = plugins.findBy 'id', +request.id
        [200, {'Content-Type': 'application/json'}, JSON.stringify(plugin: plugin)]
      @post '/api/plugins', (request) ->
        plugins.addObject
          id: 'http://__test.entry'
          url: 'http://__test.entry'
        [200, {'Content-Type': 'application/json'}, {}]
      @delete '/api/plugins/:id', (request) ->
        [200, {'Content-Type': 'application/json'}, {}]
    
  teardown: ->
    Ember.run(App, 'destroy')
    server.shutdown()

test 'Should navigate to the plugins page', ->
  visit('/').then ->
    click('a:contains("Plugins")').then ->
      shouldHaveElement 'h3:contains("These are my plugins")'

test 'Should display my plugins', ->
  visit('/plugins').then ->
    for plugin in plugins
      ok find(":contains('#{plugin.url}')").length > 0

test 'Should display explenation', ->
  visit('/plugins').then ->
    # make sure we have an explanation tag
    equal find('.plugin-explenation').length, 1
    # and that there's something in there
    ok find('.plugin-explenation').text().length > 15

test 'Should display a box to add a plugin', ->
  visit('/plugins').then ->
    # make sure we have a new kitten box
    equal find('.plugin-entry').length, 1
    # make sure there is an input field
    equal find('.plugin-entry input').length, 1
    # make sure there is a default value
    ok find('.plugin-entry input[placeholder]').length > 0

# Don't know how to run this full integration test, skipping it for now
# 
# test 'Should create a new plugin', ->
#   visit('/plugins').then ->
#     # enter the name of the new plugin
#     fillIn '.plugin-entry input', 'http://__test.entry'
#     # send the enter keycode
#     keyEvent '.plugin-entry input', 'keyup', 13
#     # find the plugin
#     andThen -> ok find(":contains('http://__test.entry')").length > 0

test 'Should remove a plugin', ->
  plugin = plugins[0]
  visit('/plugins').then ->
    ok find(":contains('#{plugin.url}')")
    click ":contains('#{plugin.url}') a:contains('remove')"
    andThen ->
      ok find(':contains("#{plugin.url}")').length == 0

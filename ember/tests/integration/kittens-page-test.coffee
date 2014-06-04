`import startApp from 'didicat/tests/helpers/start-app';`

App = null
server = null

kittens = [ {
  id: 1
  url: 'http://kittens.com/lippy'
}, {
  id: 2
  url: 'http://kittens.com/laura'
}, {
  id: 3
  url: 'http://kittens.com/poppo'
} ]

module 'Integration - Kittens page',
  setup: ->
    App = startApp()

    server = new Pretender ->
      @get '/api/kittens', (request) ->
        [200, {'Content-Type': 'application/json'}, JSON.stringify(kittens: kittens)]
      @get '/api/kittens/:id', (request) ->
        kitten = kittens.findBy 'id', +request.id
        [200, {'Content-Type': 'application/json'}, JSON.stringify(kitten: kitten)]
    
  teardown: ->
    Ember.run(App, 'destroy')
    server.shutdown()

test 'Should navigate to the kittens page', ->
  visit('/').then ->
    click('a:contains("Kittens")').then ->
      equal find('h3').text(), "These are my kittens"

test 'Should display my kittens', ->
  visit('/kittens').then ->
    for kitten in kittens
      ok find(":contains('#{kitten.url}')").length > 0

test 'Should display explenation', ->
  visit('/kittens').then ->
    # make sure we have an explanation tag
    equal find('.kitten-explenation').length, 1
    # and that there's something in there
    ok find('.kitten-explenation').text().length > 15

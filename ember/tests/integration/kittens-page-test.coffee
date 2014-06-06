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
      @post '/api/kittens', (request) ->
        [200, {'Content-Type': 'application/json'}, {}]
      @delete '/api/kittens/:id', (request) ->
        [200, {'Content-Type': 'application/json'}, {}]
    
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

test 'Should display a box to add the kitten', ->
  visit('/kittens').then ->
    # make sure we have a new kitten box
    equal find('.kitten-entry').length, 1
    # make sure there is an input field
    equal find('.kitten-entry input').length, 1
    # make sure there is a default value
    ok find('.kitten-entry input[placeholder]').length > 0

test 'Should create a new kitten', ->
  visit('/kittens').then ->
    # enter the name of the new kitten
    fillIn '.kitten-entry input', 'http://__test.entry'
    # send the enter keycode
    keyEvent '.kitten-entry input', 'keyup', 13
    # find the kitten
    andThen -> ok find(":contains('http://__test.entry')").length > 0

test 'Should remove a kitten', ->
  kitten = kittens[0]
  visit('/kittens').then ->
    ok find(":contains('#{kitten.url}')")
    click ":contains('#{kitten.url}') a:contains('remove')"
    andThen -> ok find(':contains("#{kitten.url}")').length == 0

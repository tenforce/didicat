`import startApp from 'didicat/tests/helpers/start-app';`

App = null
server = null

module 'Integration - Kittens page',
  setup: ->
    App = startApp()

    server = new Pretender ->
      @get '/api/kittens', (request) ->
        [200, {'Content-Type': 'application/json'}, null]
    
  teardown: ->
    Ember.run(App, 'destroy')
    server.shutdown()

test 'Should navigate to the requests page', ->
  visit('/').then ->
    click('a:contains("Requests")').then ->
      equal find('h3').text(), "You can send requests through this interface"

test 'Should contain a tab for sending a request to everyone', ->
  visit('/requests').then ->
    ok find('.request-builder').length >= 1
    ok find('.response').length >= 1

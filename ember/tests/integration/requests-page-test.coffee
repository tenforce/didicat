`import startApp from 'didicat/tests/helpers/start-app';`

App = null
server = null

titlesResponse = "[\"one\",\"two\"]"

module 'Integration - Kittens page',
  setup: ->
    App = startApp()

    server = new Pretender ->
      @get '/api/friends/dispatch/titles', (request) ->
        [200, {'Content-Type': 'application/json'}, titlesResponse]
    
  teardown: ->
    Ember.run(App, 'destroy')
    server.shutdown()

test 'Should navigate to the requests page', ->
  visit('/').then ->
    click('a:contains("Requests")').then ->
      equal find('h3').text(), "You can send requests through this interface"

test 'Should contain a tab for sending a request to everyone', ->
  visit('/requests').then ->
    shouldHaveElement '.request-builder'

test 'Should have an input field for the request path', ->
  visit('/requests').then ->
    shouldHaveElement '.request-builder input'

test 'Should have a button for sending the request', -> 
  visit('/requests').then ->
    shouldHaveElement 'button.send-request'

# # Sending is hooked to an ajax request at the moment, hence testing requires a timeout
# test 'Should show the response in the response block', ->
#   visit('/requests').then ->
#     # enter the titles request
#     fillIn '.request-builder input', 'titles'
#     # send the enter keycode
#     keyEvent '.request-builder input', 'keyup', 13
#     # find the kitten
#     andThen ->
#       shouldHaveElement '.response'
#       equal find('.response').text(), titlesResponse

`import startApp from 'didicat/tests/helpers/start-app'`

App = null
server = null

peers = [ {
  id: 1
  api_url: 'http://127.0.0.1:3001/peers'
  peer_url: 'http://127.0.0.1:3001/'
}, {
  id: 2,
  api_url: 'http://127.0.0.1:3002/peers'
  peer_url: 'http://127.0.0.1:3002/'
}, {
  id: 3,
  api_url: 'http://127.0.0.1:3003/peers'
  peer_url: 'http://127.0.0.1:3003/'
} ]

module 'Integration - Peers page',
  setup: ->
    App = startApp()

    server = new Pretender ->
      @get '/api/peers', (request) ->
        [200, {'Content-Type': 'application/json'}, JSON.stringify(peers: peers)]
      @get '/api/peers/:id', (request) ->
        peer = peers.findBy 'id', +request.params.id
        [200, {'Content-Type': 'application/json'}, JSON.stringify(peer: peer)]

  teardown: ->
    Ember.run(App, 'destroy')
    server.shutdown()
    
test 'Should navigate to the peer page', ->
  visit('/').then ->
    click("a:contains('peers')").then ->
      equal find('h3').text(), 'These are my peers'

test 'Should display a link to each peer', ->
  visit('/peers').then ->
    for peer in peers
      equal find("a:contains('#{peer.api_url}')").length, 1
  
test 'Should display the apiUrl and peerUrl', ->
  peer = peers.get('firstObject')
  visit("/peers/#{peer.id}").then ->
    equal find('.peer h4').text(), peer.peer_url
    equal find('.peer p').text(), peer.api_url


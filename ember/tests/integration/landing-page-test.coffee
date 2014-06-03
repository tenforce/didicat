`import startApp from 'didicat/tests/helpers/start-app';`

App = null

module 'Integration - Landing Page',
  setup: ->
    App = startApp()
  teardown: ->
    Ember.run App, 'destroy'

test 'Should welcome me to Boston Ember', ->
  visit('/').then ->
    equal find('h2#title').text(), "Hello, I'm a didiCAT peer"

test 'Should inform about what this didiCAT peer is', ->
  visit('/').then ->
    equal find('p').text(), "This is a didiCAT peer, it resides in a network of friends.  All the friends work together to offer you a unified view on a set of underlying servers."
    
test 'Should allow navigating back to home from other path', ->
  visit('/').then ->
    click("a:contains('peers')").then ->
      click("a:contains('home')").then ->
        equal find('h2#title').text(), "Hello, I'm a didiCAT peer"

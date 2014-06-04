`import startApp from 'didicat/tests/helpers/start-app';`

App = null

module 'Integration - Landing Page',
  setup: ->
    App = startApp()
  teardown: ->
    Ember.run App, 'destroy'

test 'Should welcome me to Boston Ember', ->
  visit('/').then ->
    equal find('h2#title').text(), "Hello, I'm one of didiCAT's friends."

test 'Should inform about what this didiCat friend is', ->
  visit('/').then ->
    equal find('p').text(), "I am a didiCat friend, I reside in the network of friends.  All the friends work together to offer you a unified view on a set of underlying servers."
    
test 'Should allow navigating back to home from other path', ->
  visit('/').then ->
    click("a:contains('Friends')").then ->
      click("a:contains('Home')").then ->
        equal find('h2#title').text(), "Hello, I'm one of didiCAT's friends."

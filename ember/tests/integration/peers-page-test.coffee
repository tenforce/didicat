`import startApp from 'didicat/tests/helpers/start-app'`

App = null

module 'Integration - Peers page',
  setup: ->
    App = startApp()
  teardown: ->
    Ember.run(App, 'destroy')

test 'Should navigate to the peer page', ->
  visit('/').then ->
    click("a:contains('peers')").then ->
      equal find('h3').text(), 'These are my peers'


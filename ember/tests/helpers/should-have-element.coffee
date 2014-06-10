Ember.Test.registerHelper 'shouldHaveElement', (app, selector, context) ->
  count = findWithAssert( selector , context ).length
  ok count > 0, "Found #{count} elements"

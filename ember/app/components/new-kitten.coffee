`import Ember from 'ember'`

NewKittenComponent = Ember.Component.extend
  classNames: "kitten-entry"
  actions:
    create: ->
      @sendAction 'action', @get 'url'
      @set 'url', ''
  url: ""

`export default NewKittenComponent`

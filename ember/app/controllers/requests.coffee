`import Ember from 'ember'`

RequestsController = Ember.Controller.extend
  actions:
    sendRequest: ->
      @set 'sending', true
      window.$.ajax @get('url'),
        complete: (response , status) =>
          @set 'sending', false
          @set 'response', response.responseText
          if status != "success"
            alert('the request did not complete successfully')
  response: ""          
  sending: false;
  path: ""
  url: Ember.computed 'path', ->
    '/api/friends/dispatch/' + @get('path')

`export default RequestsController`

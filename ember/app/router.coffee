`import Ember from 'ember'`

Router = Ember.Router.extend
  location: DidicatENV.locationType

Router.map ->
  @resource 'friends', ->
    @route 'show', path: ':friend_url'
  @resource 'kittens'
  @resource 'plugins'
  @route 'requests'
  @route 'config'

`export default Router`

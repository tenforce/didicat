Router = Ember.Router.extend
  location: ENV.locationType

Router.map ->
  @resource 'friends', ->
    @route 'show', path: ':friend_url'
  @resource 'kittens'
  @resource 'plugins'

`export default Router;`

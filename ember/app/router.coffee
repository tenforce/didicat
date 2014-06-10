Router = Ember.Router.extend
  location: ENV.locationType

Router.map ->
  @resource 'friends', ->
    @route 'show', path: ':id'
  @resource 'kittens'
  @resource 'plugins'

`export default Router;`

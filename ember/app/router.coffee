Router = Ember.Router.extend
  location: ENV.locationType

Router.map ->
  @resource 'friends', ->
    @route 'show', path: ':id'
  @resource 'kittens'

`export default Router;`

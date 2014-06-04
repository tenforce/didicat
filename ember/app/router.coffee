Router = Ember.Router.extend
  location: ENV.locationType

Router.map ->
  @resource 'peers', ->
    @route 'show', path: ':id'

`export default Router;`

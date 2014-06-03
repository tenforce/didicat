Router = Ember.Router.extend
  location: ENV.locationType

Router.map ->
  @resource 'peers'

`export default Router`

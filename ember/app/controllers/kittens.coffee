KittensController = Ember.ArrayController.extend
  actions:
    createKitten: (url) ->
      kitten = @store.createRecord 'kitten', url: url
      kitten.save()
    deleteKitten: (kitten) ->
      kitten.destroyRecord()
      

`export default KittensController;`

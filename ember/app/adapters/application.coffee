adapter = DS.ActiveModelAdapter.extend
  namespace: 'api'
  buildURL: (type , id) ->
    if id
      "#{@namespace}/#{@pathForType(type)}/#{encodeURIComponent id}"
    else
      "#{@namespace}/#{@pathForType(type)}"

`export default adapter`

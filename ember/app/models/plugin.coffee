`import DS from 'ember-data'`

Plugin = DS.Model.extend
  url: DS.attr    'string'
  requestMethod: DS.attr 'string'
  requestRegex:  DS.attr 'string'

`export default Plugin`

`import Ember from 'ember'`

LiLinkHelper = Ember.Handlebars.makeBoundHelper (value, target, options) ->
  outerOptions = Ember.copy options
  outerOptions.hash.tagName = "li"
  Ember.Handlebars.helpers["link-to"] "<a>#{value}</a>", target, outerOptions

`export default LiLinkHelper`

###*
 * Include a class or object with functions into another class.
 * @param  {Object} mixin               [description]
 * @param  {Boolean} wrapOldFunction  [description]
###

exports =
  bootstrap: ->
    Function::include = (mixin) ->
      if not mixin
        throw 'Supplied mixin was not found'

      if not _
        throw 'Lodash was not found'

      mixin = mixin.prototype if _.isFunction(mixin)

      # Make a copy of the superclass with the same constructor and use it instead of adding functions directly to the superclass.
      if @.__super__
        tmpSuper = _.extend({}, @.__super__)
        tmpSuper.constructor = @.__super__.constructor

      @.__super__ = tmpSuper || {}

      # Copy function over to prototype and the new intermediate superclass.
      for methodName, funct of mixin when methodName not in ['included']
        @.__super__[methodName] = funct

        if not @prototype.hasOwnProperty(methodName)
          @prototype[methodName] = funct

      mixin.included?.apply(this)
      this

if module?.exports?
  if require?
    _ = require 'lodash'

  module.exports = exports
else
  _ = window._

  window.CoffeeScriptMixins = exports

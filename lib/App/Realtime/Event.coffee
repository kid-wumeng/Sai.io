module.exports = class Event

  constructor: (options) ->
    @name     = options.name
    @callback = options.callback
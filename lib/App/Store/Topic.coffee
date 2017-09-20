module.exports = class Topic

  constructor: (options) ->
    @name   = options.name
    @filter = options.filter ? null
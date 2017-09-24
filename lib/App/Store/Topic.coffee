module.exports = class Topic

  constructor: (name, filter=null) ->
    @name   = name
    @filter = filter
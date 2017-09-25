module.exports = class EventBus

  constructor: ->
    @dict = {}


  on: (event, callback) =>
    if !@dict[event]
      @dict[event] = []
    @dict[event].push(callback)


  emit: (event, params...) =>
    if @dict[event]
      for callback in @dict[event]
        callback(params...)
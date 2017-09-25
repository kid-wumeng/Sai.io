module.exports = class EventBus

  constructor: ->
    @opens    = []
    @closes   = []
    @errors   = []
    @messages = []


  on: (event, callback) =>
    @[event+'s'].push(callback)


  emit: (event, data) =>
    for callback in @[event+'s']
      callback(data)
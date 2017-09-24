module.exports = class Subscription

  constructor: (topic, callback) ->
    @topic    = topic
    @callback = callback


  ### @Protected ###
  # 调用io
  ##
  call: (params) =>
    return @callback(params...)
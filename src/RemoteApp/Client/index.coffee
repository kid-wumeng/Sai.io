WebSocket = require('./WebSocket')



module.exports = class Client

  constructor: (url, adapter, options) ->
    @webSocket = new WebSocket(url, adapter, options)


  send: (packet, complete, timeout) ->
    @webSocket.send(packet, complete, timeout)


  on: (event, callback) ->
    @webSocket.on(event, callback)
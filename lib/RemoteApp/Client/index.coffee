WebSocket = require('./WebSocket')



module.exports = class Client

  constructor: (url, adapter, options) ->
    @webSocket = new WebSocket(url, adapter, options)


  send: (packet, callback) ->
    @webSocket.send(packet, callback)


  on: (event, callback) ->
    @webSocket.on(event, callback)
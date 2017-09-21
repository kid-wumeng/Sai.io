WebSocket = require('./WebSocket')



module.exports = class Client

  constructor: (url, adapter) ->
    @webSocket = new WebSocket(url, adapter)


  send: (packet, callback) ->
    @webSocket.send(packet, callback)
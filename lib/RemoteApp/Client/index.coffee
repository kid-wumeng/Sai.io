WebSocket = require('./WebSocket')



module.exports = class Client

  constructor: (url) ->
    @webSocket = new WebSocket(url)


  send: (packet, callback) ->
    @webSocket.send(packet, callback)
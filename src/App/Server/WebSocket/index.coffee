WS       = require('ws')
EventBus = require('./EventBus')



module.exports = class WebSocket


  constructor: ->
    @wss      = null
    @eventBus = new EventBus()



  create: (server) =>
    @wss = new WS.Server({server})
    @wss.on('connection', @onConnect)
    return server



  getSockets: =>
    return @wss.clients



  onConnect: (socket) =>
    socket.on('message', @receive.bind(@, socket))



  on: (event, callback) =>
    @eventBus.on(event, callback)



  receive: (socket, message) =>
    message = JSON.parse(message)
    @eventBus.emit('message', {socket, message})



  send: (socket, message) =>
    message = JSON.stringify(message)
    socket.send(message)
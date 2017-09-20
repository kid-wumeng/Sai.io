http      = require('http')
WebSocket = require('ws')
helper    = require('../../helper')



module.exports = class Server


  constructor: (callback) ->
    @wss = null
    @callback = callback



  listen: (port=80) =>
    server = http.createServer(@docs)
    @wss = new WebSocket.Server({server})
    @wss.on('connection', @connect)
    server.listen(port)



  docs: (req, res) =>
    res.writeHead(200, { "Content-Type": "text/html" });
    res.end("Welcome to the homepage!");



  connect: (socket) =>
    socket.on('message', @handleCall.bind(@, socket))



  handleCall: (socket, message) =>
    message = JSON.parse(message)
    helper.decodeBody(message.packet)
    message.packet = await @callback(message.packet)
    helper.encodeBody(message.packet)
    message = JSON.stringify(message)
    socket.send(message)
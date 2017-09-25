http      = require('http')
WebSocket = require('./WebSocket')



module.exports = class Server


  constructor: (rpc, rest, doc) ->
    @rpc       = rpc
    @rest      = rest
    @doc       = doc
    @webSocket = new WebSocket()



  listen: (port) =>
    server = http.createServer(@docs)
    server = @webSocket.create(server)

    @webSocket.on('message', @webSocketCallback)
    server.listen(port)



  webSocketCallback: ({socket, message}) =>
    message.packet = await @call(message.packet)
    @webSocket.send(socket, message)



  call: (packet) =>
    if packet.type is 'json-rpc'
      return await @rpc.call({}, packet)
    else
      return await @rest.call({}, packet)



  getSockets: =>
    return @webSocket.getSockets()



  docs: (req, res) =>
    if req.url is '/'
      html = await @doc.render()
      res.writeHead(200, {'Content-Type': 'text/html'})
      res.end(html)
    else
      res.writeHead(204)
      res.end()
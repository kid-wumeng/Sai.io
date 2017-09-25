http      = require('http')
WebSocket = require('./WebSocket')



module.exports = class Server


  constructor: (rpc, rest, context, midQueue, doc) ->
    @rpc       = rpc
    @rest      = rest
    @context   = context
    @midQueue  = midQueue
    @doc       = doc
    @webSocket = new WebSocket()



  listen: (port) =>
    server = http.createServer(@docs)
    server = @webSocket.create(server)

    @webSocket.on('message', @webSocketCallback)
    server.listen(port)



  webSocketCallback: ({socket, message}) =>
    ctx = @context.create({socket})
    await @midQueue.dispatch(ctx)
    packet = message.packet
    packet = await @call(ctx, packet)
    message.packet = packet
    @webSocket.send(socket, message)



  call: (ctx, packet) =>
    if packet.type is 'json-rpc'
      return await @rpc.call(ctx, packet)
    else
      return await @rest.call(ctx, packet)



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
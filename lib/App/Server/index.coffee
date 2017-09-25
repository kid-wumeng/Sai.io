http       = require('http')
Middleware = require('../Store/Middleware')
WebSocket  = require('./WebSocket')



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

    @midQueue.insert(new Middleware(@midStart))
    @midQueue.append(new Middleware(@midEnd))

    @webSocket.on('message', @webSocketCallback)
    server.listen(port)



  webSocketCallback: ({socket, message}) =>
    ctx = @context.create({
      socket:      socket
      __message:   message
      __call:      @call
      __webSocket: @webSocket
    })
    await @midQueue.dispatch(ctx)



  midStart: (next) ->
    await next()
    @__webSocket.send(@socket, @__message)



  midEnd: ->
    packet = @__message.packet
    packet = await @__call(@, packet)
    @__message.packet = packet



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
http      = require('http')
WebSocket = require('ws')
SaiJSON   = require('../../assets/SaiJSON')
adapter   = require('../../assets/SaiJSONAdapter')



module.exports = class Server


  constructor: (callback, doc) ->
    @wss      = null
    @saiJSON  = new SaiJSON(adapter)
    @callback = callback
    @doc      = doc



  listen: (port=80) =>
    server = http.createServer(@docs)
    @wss = new WebSocket.Server({server})
    @wss.on('connection', @connect)
    server.listen(port)



  docs: (req, res) =>
    if req.url is '/'
      html = await @doc.render()
      res.writeHead(200, {'Content-Type': 'text/html'})
      res.end(html)
    else
      res.writeHead(204)
      res.end()



  connect: (socket) =>
    socket.on('message', @handleCall.bind(@, socket))



  handleCall: (socket, message) =>
    # 收信
    message = JSON.parse(message)
    packet  = message.packet
    @saiJSON.decode packet, =>
      # 执行
      packet = await @callback(packet)
      # 回信
      @saiJSON.encode packet, =>
        message.packet = packet
        message = JSON.stringify(message)
        socket.send(message)
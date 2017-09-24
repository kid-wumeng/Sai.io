WS     = require('ws')
errors = require('../../errors')


module.exports = class WebSocket

  constructor: ->
    @wss = null



  createServer: (server) =>
    wss = new WS.Server({server})
    wss.on('connection', @onCollection)
    return server



  onCollection: (socket) =>
    socket.on('message', @onMessage.bind(@, socket))



  onMessage: (socket, packet) ->
    packet = JSON.parse(packet)




  publish: (topic, data={}) =>
    topic = @topics[topic]
    if(topic)
      @server.clients.forEach((client) => @publishEach(topic, data, client))
      # topic.filter (data)
    else
      throw errors.TOPIC_NOT_FOUND(topic)



  publishEach: (topic, data, client) =>
    if topic.filter.call(client, data)
      client.send(JSON.stringify(data))
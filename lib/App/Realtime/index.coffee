WebSocket = require('ws')
errors    = require('../../errors')


module.exports = class Realtime

  constructor: ({server, topics, events}) ->
    @server = new WebSocket.Server({server})
    @server.on('connection', @onCollection)
    @topics = topics
    @events = events



  onCollection: (socket) =>
    socket.on('message', @onMessage.bind(@, socket))



  onMessage: (socket, packet) ->
    packet = JSON.parse(packet)
    event  = packet.event
    params = packet.params ? []

    event = @events[event]
    if(event)
      event.callback.call(socket, params...)
    else
      throw errors.EVENT_NOT_FOUND(event)



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
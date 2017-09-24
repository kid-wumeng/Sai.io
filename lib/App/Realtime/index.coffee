_      = require('lodash')
errors = require('../../errors')



module.exports = class RPC

  constructor: (store, server) ->
    @store  = store
    @server = server



  publish: (topic_name, params) =>
    topic = @store.topics[topic_name]
    if(topic)
      packet = @getPacket(topic, params)
      sockets = @server.getSockets()
      sockets.forEach (socket) =>
        @publishEach(topic, params, socket, packet)
    else
      throw errors.TOPIC_NOT_FOUND(topic)



  publishEach: (topic, params, socket, packet) =>
    if !topic.filter
      socket.send(packet)
    else if (await topic.filter(params...)) is true
      socket.send(packet)



  getPacket: (topic, params) =>
    return JSON.stringify({
      topic: topic.name
      params: params
    })
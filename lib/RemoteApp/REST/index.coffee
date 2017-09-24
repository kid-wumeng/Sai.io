Task = require('./Task')



module.exports = class RPC

  constructor: (client, store) ->
    @client = client
    @store  = store



  get: (path) =>
    task = new Task({
      method: 'GET'
      path: path
      store: @store
    })
    @send(task)
    return task



  send: (task) =>
    setTimeout =>
      packet   = task.getPacket()
      complete = task.complete
      timeout  = task.timeout
      @client.send(packet, complete, timeout)
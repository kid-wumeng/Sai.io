Task = require('./Task')



module.exports = class RPC

  constructor: (client, global_dones, global_fails) ->
    @client = client
    @global_dones = global_dones
    @global_fails = global_fails



  get: (path) =>
    task = new Task({
      method: 'GET'
      path: path
      global_dones: @global_dones
      global_fails: @global_fails
    })
    @send(task)
    return task



  send: (task) =>
    setTimeout =>
      packet   = task.getPacket()
      complete = task.complete
      timeout  = task.timeout
      @client.send(packet, complete, timeout)
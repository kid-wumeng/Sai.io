uuidv4 = require('uuid/v4')
Task   = require('../Task')



module.exports = class Task extends Task

  constructor: ({ method, path, data, global_dones, global_fails }) ->
    super(
      global_dones,
      global_fails
    )
    @method = method
    @path   = path
    @data   = data



  getPacket: =>
    return
      type: 'rest'
      task:
        method: @method
        path:   @path
        data:   @data
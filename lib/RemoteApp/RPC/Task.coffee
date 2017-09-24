uuidv4 = require('uuid/v4')
Task   = require('../Task')



module.exports = class Task extends Task

  constructor: (method, params, store) ->
    super(store)
    @method = method
    @params = params
    @id     = uuidv4()



  getPacket: =>
    return
      jsonrpc: '2.0'
      method: @method
      params: @params
      id:     @id
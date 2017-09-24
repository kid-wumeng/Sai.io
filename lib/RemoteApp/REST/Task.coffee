Task = require('../Task')



module.exports = class Task extends Task

  constructor: ({method, path, data, store}) ->
    super(store)
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
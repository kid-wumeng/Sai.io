Task = require('../Task')



module.exports = class Task extends Task

  constructor: ({method, path, data, store}) ->
    super(store)
    @method = method
    @path   = @formatPath(path)
    @data   = data


  formatPath: (path) =>
    if path[0] is '/'
      path = path.slice(1)
    return path


  getPacket: =>
    return
      type: 'rest'
      task:
        method: @method
        path:   @path
        data:   @data
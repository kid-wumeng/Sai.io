Task = require('../Task')



module.exports = class Task extends Task

  constructor: ({method, path, data, store}) ->
    super(store)
    @method = method
    @path   = @formatPath(path)
    @data   = data


  formatPath: (path) =>
    if path[0] isnt '/'
      path = '/' + path
    return path


  getPacket: =>
    return
      type: 'rest'
      task:
        method: @method
        path:   @path
        data:   @data
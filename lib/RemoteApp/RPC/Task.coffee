uuidv4 = require('uuid/v4')



module.exports = class Task

  constructor: (method, params) ->
    @method = method
    @params = params
    @id     = uuidv4()

    @dones  = []
    @fails  = []

    @result = null
    @error  = null



  done: (callback) =>
    @dones.push(callback)
    return @



  fail: (callback) =>
    @fails.push(callback)
    return @



  always: (callback) =>
    @dones.push(callback)
    @fails.push(callback)
    return @



  getPacket: =>
    return
      jsonrpc: '2.0'
      method: @method
      params: @params
      id:     @id



  complete: ({result, error}) =>
    if error
      @error = error
      for fail in @fails then fail(error, @)
    else
      @result = result
      for done in @dones then done(result, @)
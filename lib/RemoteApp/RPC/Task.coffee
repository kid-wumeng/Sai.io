uuidv4 = require('uuid/v4')
REQUEST_TIMEOUT = require('../../errors/REQUEST_TIMEOUT')



module.exports = class Task

  constructor: (method, params, global_dones, global_fails) ->
    @method = method
    @params = params
    @id     = uuidv4()

    @global_dones = global_dones
    @global_fails = global_fails
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
      @completeByFail(error)
    else
      @completeByDone(result)



  completeByFail: (error) =>
    if @fails.length
      for fail in @fails then fail(error, @)
    else
      for fail in @global_fails then fail(error, @)



  timeout: =>
    @error = REQUEST_TIMEOUT()
    @completeByFail(@error, @)
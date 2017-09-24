REQUEST_TIMEOUT = require('../../errors/REQUEST_TIMEOUT')



module.exports = class Task

  constructor: (store) ->
    @store  = store
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



  complete: ({result, error}) =>
    if error
      @completeByFail(error)
    else
      @completeByDone(result)



  completeByDone: (result) =>
    if @dones.length
      for done in @dones then done(result, @)
    else
      @store.emit('done', result)



  completeByFail: (error) =>
    if @fails.length
      for fail in @fails then fail(error, @)
    else
      @store.emit('fail', error)



  timeout: =>
    @error = REQUEST_TIMEOUT()
    @completeByFail(@error, @)
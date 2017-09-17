axios  = require('axios')
uuidv4 = require('uuid/v4')
helper = require('../helper')



module.exports = class Task

  constructor: (options={}) ->
    @host   = options.host
    @method = options.method
    @params = options.params
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



  send: () =>
    requestBody =
      jsonrpc: '2.0'
      id:     @id
      method: @method
      params: @params

    helper.encodeBody(requestBody)
    axios
      .post(@host, requestBody)
      .then(@receive)



  receive: (response) =>
    helper.decodeBody(response.data)
    @complete(response.data)



  complete: ({result, error}) =>
    if error
      @error = error
      for fail in @fails then fail(error, @)
    else
      @result = result
      for done in @dones then done(result, @)
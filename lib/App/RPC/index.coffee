_      = require('lodash')
errors = require('../../errors')



module.exports = class RPC


  constructor: (store) ->
    @store = store



  call: (ctx, packet) =>
    if Array.isArray(packet)
      promises = packet.map (task) => @callOne(ctx, task)
      return Promise.all(promises)
    else
      task = packet
      return await @callOne(ctx, task)



  # @TODO 处理json-rpc通知
  callOne: (ctx, task) =>
    jsonrpc = '2.0'
    id      = task.id

    try
      method = @getMethod(task.method)
      params  = task.params
      result = await method.call(ctx, params)
      return { jsonrpc, result, id }
      
    catch error
      error = _.pick(error, ['code', 'message', 'data'])
      return { jsonrpc, error, id }



  ### @Private ###
  getMethod: (name) =>
    method = @store.methods[name]
    if method
      return method
    else
      throw errors.METHOD_NOT_FOUND(name)
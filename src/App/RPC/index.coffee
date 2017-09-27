_        = require('lodash')
bluebird = require('bluebird')
errors   = require('../../errors')
assets   = require('../../assets')
SaiJSON  = require('../../assets/SaiJSON')
adapter  = require('../../assets/SaiJSONAdapter')
globalEventBus = require('../../assets/globalEventBus')



module.exports = class RPC


  constructor: (store) ->
    @store   = store
    @saiJSON = new SaiJSON(adapter)

    bluebird.promisifyAll(@saiJSON)



  call: (ctx, packet) =>
    await @saiJSON.decodeAsync(packet)
    packet = await @invoke(ctx, packet)
    await @saiJSON.encodeAsync(packet)
    return packet



  invoke: (ctx, packet) =>
    if packet.batch
      return await @invokeMany(ctx, packet.tasks)
    else
      return await @invokeOne(ctx, packet.task)



  invokeMany: (ctx, tasks) =>
    promises = tasks.map (task) => @invokeOne(ctx, task)
    return Promise.all(promises)



  # @TODO 处理json-rpc通知
  invokeOne: (ctx, task) =>
    jsonrpc = '2.0'
    id      = task.id

    try
      method = @getMethod(task.method)
      params = task.params
      result = await method.call(ctx, params)
      return { jsonrpc, result, id }

    catch error
      error = assets.error(ctx, error)
      globalEventBus.emit('error', error)
      delete error.stack
      return { jsonrpc, error, id }



  ### @Private ###
  getMethod: (name) =>
    method = @store.methods[name]
    if method
      return method
    else
      throw errors.METHOD_NOT_FOUND(name)
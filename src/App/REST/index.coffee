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
    return await @invokeOne(ctx, packet.task)



  invokeOne: (ctx, task) =>
    try
      { route, params } = @match(task)
      result = await route.call(ctx, params)
      return { result }

    catch error
      error = assets.error(ctx, error)
      globalEventBus.emit('error', error)
      return { error }



  match: (task) =>
    for route in @getRoutes(task)
      params = @matchEach(route, task)
      if params
        return { route, params }

    throw errors.ROUTE_NOT_FOUND(task.method, task.path)



  matchEach: (route, task) =>
    result = route.reg.exec(task.path)
    if result
      params = result.slice(1)
      @formatNumberParams(params)
      return params
    else
      return null



  formatNumberParams: (params) =>
    for param, i in params
      if /^\d+(?:\.\d+)?$/.test(param)
        params[i] = parseFloat(param)



  getRoutes: (task) =>
    switch task?.method
      when 'GET'    then @store.gets
      when 'POST'   then @store.posts
      when 'PUT'    then @store.puts
      when 'PATCH'  then @store.patchs
      when 'DELETE' then @store.deletes
      else []
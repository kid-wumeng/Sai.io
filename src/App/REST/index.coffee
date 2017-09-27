_              = require('lodash')
qs             = require('querystring')
bluebird       = require('bluebird')
errors         = require('../../errors')
assets         = require('../../assets')
SaiJSON        = require('../../assets/SaiJSON')
adapter        = require('../../assets/SaiJSONAdapter')
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
      @splitPathAndQuery(task)
      route = @match(task)
      { params, query } = task
      params.push(query)
      result = await route.call(ctx, params)
      return { result }

    catch error
      error = assets.error(ctx, error)
      globalEventBus.emit('error', error)
      delete error.stack
      return { error }



  splitPathAndQuery: (task) =>
    [ path, queryString ] = task.path.split('?')
    task.path = path

    if(queryString)
      task.query = @parseQuery(queryString)
    else
      task.query = {}



  parseQuery: (queryString) =>
    query = qs.parse(queryString)
    for name, value of query
      query[name] = @formatString(value)
    return query



  getRoutes: (task) =>
    switch task?.method
      when 'GET'    then @store.gets
      when 'POST'   then @store.posts
      when 'PUT'    then @store.puts
      when 'PATCH'  then @store.patchs
      when 'DELETE' then @store.deletes
      else []



  match: (task) =>
    for route in @getRoutes(task)
      if @matchEach(route, task)
        return route

    throw errors.ROUTE_NOT_FOUND(task.method, task.path)



  matchEach: (route, task) =>
    result = route.reg.exec(task.path)
    if result
      params = result.slice(1)
      params = params.map (param) => @formatString(param)
      task.params = params
      return true
    else
      task.params = []
      return false



  formatString: (string) =>
    if /^\d+(?:\.\d+)?$/.test(string)
      return parseFloat(string)
    else
      return string
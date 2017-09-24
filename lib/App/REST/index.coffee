_      = require('lodash')
errors = require('../../errors')



module.exports = class RPC

  constructor: (store) ->
    @store = store



  call: (ctx, task) =>
    try
      routes = @getRoutes(task)
      { route, params }  = @match(task, routes)
      @formatNumberParams(params)
      result = await route.call(ctx, params)
      return {result}

    catch error
      error = _.pick(error, ['code', 'message', 'data'])
      return {error}



  getRoutes: (task) =>
    switch task.method
      when 'GET'    then @store.gets
      when 'POST'   then @store.posts
      when 'PUT'    then @store.puts
      when 'PATCH'  then @store.patchs
      when 'DELETE' then @store.deletes



  match: (task, routes) =>
    { method, path } = task
    for route in routes
      result = route.reg.exec(path)
      if result
        params = result.slice(1)
        return { route, params }
    throw errors.ROUTE_NOT_FOUND(method, path)



  formatNumberParams: (params) =>
    for param, i in params
      if /^\d+(?:\.\d+)?$/.test(param)
        params[i] = parseFloat(param)
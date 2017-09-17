_      = require('lodash')
errors = require('../errors')



module.exports = class RPC

  constructor: (options) ->
    @methods = options.methods



  execute: (ctx) =>
    if Array.isArray(ctx.requestBody)
      tasks = ctx.requestBody
      ctx.responseBody = await @executeMany(tasks, ctx)
    else
      task = ctx.requestBody
      ctx.responseBody = await @executeOne(task, ctx)



  executeMany: (tasks, ctx) =>
    promises = tasks.map (task) => @executeOne(task, ctx)
    return Promise.all(promises)



  executeOne: (task, ctx) =>
    method = task.method
    params = task.params
    id     = task.id

    try
      result = await @callMethod(method, params, ctx)
    catch error
      error = _.pick(error, ['code', 'message', 'data'])

    return{ jsonrpc: '2.0', result, error, id }



  ### @Private ###
  callMethod: (name, params, ctx) =>
    method = @methods[name]
    if method
      return method.call(ctx, params)
    else
      throw errors.METHOD_NOT_FOUND(name)
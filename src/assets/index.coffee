_ = require('lodash')


exports.error = (ctx, error) =>
  if _.isString(error)
    error = { message: error }

  keys  = ['code', 'message', 'data']
  error = _.pick(error, keys)

  error.ioChain = ctx.ioChain if ctx.ioChain.length
  error.ioStack = ctx.ioStack if ctx.ioStack.length
  error.method  = ctx.method  if ctx.method
  error.path    = ctx.path    if ctx.path

  return error
_ = require('lodash')


exports.error = (ctx, error) =>
  if _.isString(error)
    error = { message: error }

  keys  = ['code', 'message', 'data']
  error = _.pick(error, keys)

  error.ioChain = ctx.ioChain
  error.ioStack = ctx.ioStack

  return error
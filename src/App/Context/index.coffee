_      = require('lodash')
errors = require('../../errors')


module.exports = class Context

  constructor: (store) ->
    @store = store


  create: (ctx={}) =>
    Object.assign(ctx, @store.mounts)
    ctx.call    = @call.bind(ctx, @store.ios)
    ctx.ioChain = []
    ctx.ioStack = []
    ctx.io      = @bindIOs(ctx)
    return ctx


  call: (ios, name, params...) ->
    io = ios[name]
    if io
      return io.call(@, params)
    else
      throw errors.IO_NOT_FOUND(name)


  bindIOs: (ctx) =>
    dict = {}
    ios = @store.ios
    for name, io of ios
      _.set dict, name, do
        (name) ->
          (params...) ->
            ctx.call(name, params...)
    return dict
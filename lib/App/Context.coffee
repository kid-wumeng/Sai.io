_      = require('lodash')
helper = require('../helper')
errors = require('../errors')



module.exports = class Context


  @format: (ctx={}, {ios, mounts}) =>
    Object.assign(ctx, mounts)
    ctx.call  = @call.bind(null, ctx, ios)
    ctx.throw = @throw
    ctx.ioChain = []
    ctx.ioStack = []
    return ctx



  ### @Public ###
  # @call(name, params...)
  # ctx与ios已通过bind()绑定
  ##
  @call: (ctx, ios, name, params...) ->
    io = ios[name]
    if(io)
      ctx.ioChain.push(name)
      ctx.ioStack.push(name)
      result = io.call(ctx, params)
      ctx.ioStack.pop()
      return result
    else
      throw errors.IO_NOT_FOUND(name)



  ### @Public ###
  # @throw(args...)
  ##
  @throw: (args...) ->
    a1 = args[0]
    a2 = args[1]
    a3 = args[2]

    overload = helper.overload
    switch
      when overload(args, Number)                 then status  = a1
      when overload(args, String)                 then message = a1
      when overload(args, Object)                 then options = a1
      when overload(args, Number, String)         then status  = a1; message = a2
      when overload(args, Number, Object)         then status  = a1; options = a2
      when overload(args, String, Object)         then message = a1; options = a2
      when overload(args, Number, String, Object) then status  = a1; message = a2; options = a3

    error        = new Error(message)
    error.status = status
    error.code   = options?.code
    error.data   = options?.data
    throw error
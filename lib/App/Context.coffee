_            = require('lodash')
helper       = require('../helper')
IO_Not_Found = require('./errors/IO_Not_Found')



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
      IO_Not_Found(name)



  ### @Public ###
  # @throw(args...)
  ##
  @throw: (args...) ->
    a1 = args[0]
    a2 = args[1]
    a3 = args[2]
    switch args.length
      when 1
        # @throw(message)
        helper.throw({message: a1})
      when 2
        switch
          # @throw(status, message)
          when _.isNumber(a1) and _.isString(a2)      then helper.throw({status: a1,  message: a2})
          # @throw(message, data)
          when _.isString(a1) and _.isPlainObject(a2) then helper.throw({message: a1, data: a2})
      when 3
        # @throw(status, message, data)
        helper.throw({status: a1, message: a2, data: a3})
      else
        helper.throw()
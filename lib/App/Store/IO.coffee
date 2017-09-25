module.exports = class IO

  constructor: (options) ->
    @name = options.name
    @func = options.func


  ### @Protected ###
  # 调用io
  ##
  call: (ctx, params) =>
    ctx.ioChain.push(@name)
    ctx.ioStack.push(@name)
    result = await @func.call(ctx, params...)
    ctx.ioStack.pop()
    return result
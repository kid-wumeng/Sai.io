module.exports = class IO

  constructor: (name, func) ->
    @name = name
    @func = func


  ### @Protected ###
  # 调用io
  ##
  call: (ctx, params) =>
    ctx.ioChain.push(@name)
    ctx.ioStack.push(@name)
    result = @func.call(ctx, params...)
    ctx.ioStack.pop()
    return result
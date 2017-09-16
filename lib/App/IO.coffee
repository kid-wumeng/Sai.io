module.exports = class IO

  constructor: (options) ->
    @name = options.name
    @func = options.func


  ### @Protected ###
  # 调用io
  ##
  call: (ctx, params) =>
    return @func.call(ctx, params...)
module.exports = class Method

  constructor: (options) ->
    @name = options.name
    @io   = options.io


  ### @Protected ###
  # 调用io
  ##
  call: (ctx, params) =>
    return @io.call(ctx, params)
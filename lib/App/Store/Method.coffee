module.exports = class Method

  constructor: (name, io, options={}) ->
    @name   = name
    @io     = io
    @desc   = options.desc ? ''
    @params = options.params ? []


  ### @Protected ###
  # 调用io
  ##
  call: (ctx, params) =>
    return @io.call(ctx, params)
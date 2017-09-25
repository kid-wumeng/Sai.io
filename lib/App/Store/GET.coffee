pathToRegexp = require('path-to-regexp')


module.exports = class Method

  constructor: (path, io, options={}) ->
    @method = 'GET'
    @path   = path
    @keys   = []
    @reg    = pathToRegexp(@path, @keys)
    @io     = io
    @desc   = options.desc   ? ''
    @params = options.params ? []
    @query  = options.query  ? []
    @data   = options.data   ? []



  ### @Protected ###
  # 调用get
  ##
  call: (ctx, params) =>
    ctx.method = @method
    ctx.path   = @path
    return @io.call(ctx, params)
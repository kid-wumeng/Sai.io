pathToRegexp = require('path-to-regexp')


module.exports = class Method

  constructor: (path, io, options={}) ->
    @method = 'GET'
    @path   = @formatPath(path)
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
  formatPath: (path) =>
    if path[0] is '/'
      path = path.slice(1)
    return path



  ### @Protected ###
  # 调用get
  ##
  call: (ctx, params) =>
    ctx.method = @method
    ctx.path   = @path
    return @io.call(ctx, params)
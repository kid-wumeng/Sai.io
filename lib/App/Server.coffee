Koa    = require('koa')
helper = require('../helper')



module.exports = class Method

  constructor: (options) ->
    @port     = options.port
    @callback = options.callback
    @koa      = new Koa()



  ### @Protected ###
  # 启动服务器
  ##
  start: =>
    @koa.use(@getRequestBody)
    @koa.use(@decodeRequestBody)
    @koa.use(@encodeResponseBody)
    @koa.use(@setResponseBody)
    @koa.use(@callback)
    return @koa.listen(@port)



  getRequestBody: (ctx, next) =>
    ctx.requestBody = ''
    ctx.req.on('data', (chunk) => ctx.requestBody += chunk)
    await new Promise((resolve) => ctx.req.on('end', resolve))
    await next()



  decodeRequestBody: (ctx, next) =>
    body = ctx.requestBody
    body = JSON.parse(body)
    helper.decodeBody(body)
    ctx.requestBody = body
    await next()



  encodeResponseBody: (ctx, next) =>
    await next()
    helper.encodeBody(ctx.responseBody)



  setResponseBody: (ctx, next) =>
    ctx.responseBody = {}  # 提前准备好responseBody，到callback时会用到
    await next()
    ctx.body = ctx.responseBody
_      = require('lodash')
Koa    = require('koa')
helper = require('../helper')



module.exports = class App



  constructor: (options={}) ->
    @port     = options.port
    @ios      = {}
    @services = {}
    @mounts   = {}
    @koa      = new Koa()



  # @PUBLIC
  config: (key, value) =>
    @[key] = value



  # @PUBLIC
  io: (name, fn) =>
    @ios[name] = fn



  # @PUBLIC
  call: (name, data={}, ctx) =>
    io = @ios[name]
    if(io)
      ctx = @formatContext(ctx)
      ctx.ioChain.push(name)
      return io.call(ctx, data)
    else
      ioNotFound({name})



  formatContext: (ctx={}) =>
    Object.assign(ctx, @mounts)
    ctx.ioChain = []
    ctx.call    = @callInContext.bind(ctx, @ios)
    ctx.throw   = @throwInContext
    return ctx



  callInContext: (ios, name, data={}) ->
    io = ios[name]
    if(io)
      @ioChain.push(name)
      return io.call(@, data)
    else
      ioNotFound({name})



  throwInContext: (args...) ->
    a1 = args[0]
    a2 = args[1]
    a3 = args[2]
    switch args.length
      when 1
        helper.throw({message: a1})
      when 2
        switch
          when _.isNumber(a1) and _.isString(a2)      then helper.throw({status: a1,  message: a2})
          when _.isString(a1) and _.isPlainObject(a2) then helper.throw({message: a1, info: a2})
      when 3
        helper.throw({status: a1, message: a2, info: a3})
      else
        helper.throw()



  # @PUBLIC
  service: (name, io) =>
    @services[name] =
      io: io



  callService: (name, data, ctx) =>
    service = @services[name]
    if(service)
      return @call(service.io, data, ctx)
    else
      serviceNotFound({name})



  # @PUBLIC
  mount: (key, value) =>
    @mounts[key] = value



  # @PUBLIC
  start: (message) =>
    @koa.use(@decodeServiceName)
    @koa.use(@getRequestBody)
    @koa.use(@decodeRequestBody)
    @koa.use(@encodeResponseBody)
    @koa.use(@setResponseBody)
    @koa.use(@callback)

    @koa.listen(@port)
    message ?= "sai-io app:#{@port} start ~ !"
    console.log message.green



  decodeServiceName: (ctx, next) =>
    ctx.serviceName = ctx.path.slice(1)
    await next()



  getRequestBody: (ctx, next) =>
    ctx.requestBody = ''
    ctx.req.on('data', (chunk) => ctx.requestBody += chunk)
    await new Promise((resolve) => ctx.req.on('end', resolve))
    await next()



  decodeRequestBody: (ctx, next) =>
    body = ctx.requestBody
    body = JSON.parse(body)
    helper.decodeBody(body)
    ctx.responseBody = body
    await next()



  encodeResponseBody: (ctx, next) =>
    await next()
    helper.encodeBody(ctx.responseBody)



  setResponseBody: (ctx, next) =>
    ctx.responseBody = {}
    await next()
    ctx.body = ctx.responseBody



  callback: (ctx) =>
    try
      name = ctx.serviceName
      data = ctx.requestBody.data
      data = await @callService(name, data, ctx)
      ctx.responseBody.data = data
    catch error
      @catch(ctx, error)



  catch: (ctx, error) =>
    if(error.bySai)
      # bySai标志位为true，表示这个error：
      # 1. 由Sai系统抛出
      # 2. 由开发者调用@throw抛出
      ctx.status = error.status
      ctx.responseBody.error =
        code:        error.code
        message:     error.message
        info:        error.info
        serviceName: ctx.serviceName
        ioChain:     ctx.ioChain
    else
      # 否则，是由开发者使用throw关键词抛出
      ctx.status = 500
      ctx.responseBody.error =
        message:     error.toString()
        serviceName: ctx.serviceName
        ioChain:     ctx.ioChain



ioNotFound = ({name}) =>
  helper.throw({
    status: 404
    code: 10001
    zh_message: "IO ~ #{name} ~ 未找到，是不是没用 app.io() 注册？"
    info: {name}
  })



serviceNotFound = ({name}) =>
  helper.throw({
    status: 404
    code: 10001
    zh_message: "服务 ~ #{name} ~ 未找到，是不是没用 app.service() 注册？"
    info: {name}
  })
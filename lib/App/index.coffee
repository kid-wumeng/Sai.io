_      = require('lodash')
Koa    = require('koa')
helper = require('../helper')



###
# 动态上下文(ctx，即this)在io被调用时自动注入
#
# 当通过app,call()在本地调用io时，ctx包含以下内容：
# 1. Sai默认属性
# 2. mounts，即开发者手动装载的属性
#
# 当通过网络请求调用io时，ctx包含以下内容：
# 1. Sai默认属性
# 2. mounts，即开发者手动装载的属性
# 3. koa-ctx的属性
#
# Sai默认属性由Sai自动装载，而且是安全属性（无法被覆写），属性一览：
#
# * {function} call(ioName, data)
# - 调用io
#
# * {function} throw([status], message, [info])
# - 抛出异常，这是Sai推荐的做法（而不是使用JS原生的throw关键词），接口与koa-throw保持一致
#
# * {string} serviceName
# - 请求的服务名，仅在网络调用时存在本属性
#
# * {string[]} ioChain
# - 记录io调用链，例如['User.login', 'User.checkPassword', ...], 开发者不应该修改本属性
#
# * {string[]} ioStack
# - 记录io调用链，例如['User.login', 'User.checkPassword', ...], 开发者不应该修改本属性
# - 与ioChain的唯一区别是，当执行完一个io时，其记录将出栈
# - 正常执行完毕整个服务请求后，ioStack应该为空数组
# - 如果执行期间发生异常，通过比对ioChain与ioStack，能一目了然是在哪一环出现了问题
###



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
      ctx.ioStack.push(name)
      result = io.call(ctx, data)
      ctx.ioStack.pop()
      return result
    else
      ioNotFound({name})



  formatContext: (ctx={}) =>
    Object.assign(ctx, @mounts)
    ctx.call    = @callInContext.bind(ctx, @ios)
    ctx.throw   = @throwInContext
    ctx.ioChain = []
    ctx.ioStack = []
    return ctx



  callInContext: (ios, name, data={}) ->
    io = ios[name]
    if(io)
      @ioChain.push(name)
      @ioStack.push(name)
      result = io.call(@, data)
      @ioStack.pop()
      return result
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
        ioStack:     ctx.ioStack
    else
      # 否则，是由开发者使用throw关键词抛出
      ctx.status = 500
      ctx.responseBody.error =
        message:     error.toString()
        serviceName: ctx.serviceName
        ioChain:     ctx.ioChain
        ioStack:     ctx.ioStack



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
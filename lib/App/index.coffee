_      = require('lodash')
Koa    = require('koa')
config = require('../config')
helper = require('../helper')
error  = require('./error')



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
# {function} call(ioName, data)
# 调用io
#
# {function} throw([status], message, [data])
# 抛出异常，这是Sai推荐的做法（而不是使用JS原生的throw关键词），接口与koa-throw保持一致
#
# {string} serviceName
# 请求的服务名，仅在网络调用时存在本属性
#
# {string[]} ioChain
# 记录io调用链，例如['User.login', 'User.checkPassword', ...], 开发者不应该修改本属性
#
# {string[]} ioStack
# 记录io调用链，例如['User.login', 'User.checkPassword', ...], 开发者不应该修改本属性
# 与ioChain的唯一区别是，当执行完一个io时，其记录将出栈
# 正常执行完毕整个服务请求后，ioStack应该为空数组
# 如果执行期间发生异常，通过比对ioChain与ioStack，能一目了然是在哪一环出现了问题
###



module.exports = class App

  constructor: (options={}) ->
    @port     = options.port
    @ios      = {}
    @services = {}
    @mounts   = {}
    @koa      = new Koa()



  ### @PUBLIC ###
  # 配置
  ##
  config: (key, value) =>
    @[key] = value



  ### @PUBLIC ###
  # 注册io
  ##
  io: (name, fn) =>
    @ios[name] = fn



  ### @PUBLIC ###
  # 调用io
  ##
  callIO: (name, params, ctx) =>
    io = @ios[name]
    if(io)
      ctx = @formatContext(ctx)
      ctx.ioChain.push(name)
      ctx.ioStack.push(name)
      result = io.call(ctx, params...)
      ctx.ioStack.pop()
      return result
    else
      error.IO_Not_Found({ioName: name})



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
      error.IO_Not_Found({ioName: name})



  throwInContext: (args...) ->
    a1 = args[0]
    a2 = args[1]
    a3 = args[2]
    switch args.length
      when 1
        # @throw(message)
        error.throw({message: a1})
      when 2
        switch
          # @throw(status, message)
          when _.isNumber(a1) and _.isString(a2)      then error.throw({status: a1,  message: a2})
          # @throw(message, data)
          when _.isString(a1) and _.isPlainObject(a2) then error.throw({message: a1, data: a2})
      when 3
        # @throw(status, message, data)
        error.throw({status: a1, message: a2, data: a3})
      else
        error.throw()



  ### @PUBLIC ###
  # 注册服务
  ##
  service: (name, io) =>
    @services[name] =
      io: io



  callService: (name, params, ctx) =>
    service = @services[name]
    if(service)
      return @callIO(service.io, params, ctx)
    else
      error.Service_Not_Found({serviceName: name})



  ### @PUBLIC ###
  # 挂载属性到ctx上
  ##
  mount: (key, value) =>
    @mounts[key] = value



  ### @PUBLIC ###
  # 启动app
  ##
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
    ctx.requestBody = body
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
      params = ctx.requestBody.params
      result = await @callService(name, params, ctx)
      ctx.responseBody.result = result
    catch error
      @catch(ctx, error)



  catch: (ctx, error={}) =>
    # 可能开发者会直接使用 throw 'some messages...'
    # 则需要包装成error对象
    if _.isString(error)
      error = message: error

    # 表明此异常由http请求触发
    error.byHTTPRequest = true
    error.serviceName   = ctx.serviceName
    error.ioChain       = ctx.ioChain
    error.ioStack       = ctx.ioStack

    # 本地全局捕获
    config.onCatch(error)

    # 响应：只返回必要的错误信息
    ctx.status = error.status ? 400
    ctx.responseBody.error = _.pick(error, [
      'code'
      'message'
      'data'
      'serviceName'
      'ioChain'
      'ioStack'
    ])
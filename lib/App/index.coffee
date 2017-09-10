Koa   = require('koa')
error = require('../error')



ioNotFound = ({name}) =>
  error({
    code: 10001
    zh_message: "IO ~ #{name} ~ 未找到，是不是没用 app.io() 注册？"
    data: {name}
  })



serviceNotFound = ({name}) =>
  error({
    code: 10001
    zh_message: "服务 ~ #{name} ~ 未找到，是不是没用 app.service() 注册？"
    data: {name}
  })



module.exports = class App



  constructor: (options={}) ->
    @port     = options.port
    @ios      = {}
    @services = {}
    @koa      = new Koa()



  config: (key, value) =>
    @[key] = value



  io: (name, fn) =>
    @ios[name] = fn



  call: (name, data={}) =>
    io = @ios[name]
    if(io)
      return io(data)
    else
      ioNotFound({name})



  service: (name, io) =>
    @services[name] =
      io: io



  callService: (name, data) =>
    service = @services[name]
    if(service)
      return @call(service.io, data)
    else
      serviceNotFound({name})



  start: (message) =>
    @koa.use(@getRequestBody)
    @koa.use(@decodeRequestBody)
    @koa.use(@callback)
    @koa.listen(@port)

    message ?= "sai-io app:#{@port} start ~ !"
    console.log message.green



  getRequestBody: (ctx, next) =>
    ctx.requestBody = ''
    ctx.req.on('data', (chunk) => ctx.requestBody += chunk)
    await new Promise((resolve) => ctx.req.on('end', resolve))
    await next()



  decodeRequestBody: (ctx, next) =>
    ctx.requestBody = JSON.parse(ctx.requestBody, @decodeRequestBodyEach.bind(this))
    await next()



  decodeRequestBodyEach: (key, value) =>
    dateRegExp = /^\/Date\(\d+\)\/$/
    fileRegExp = /^\/File\(.+\)\/$/
    if dateRegExp.test(value) then return @decodeDate(value)
    if fileRegExp.test(value) then return @decodeFile(value)
    return value



  encodeDate: (date) =>
    timeStamp = date.getTime()
    return "/Date(#{timeStamp})/"



  decodeDate: (dateString) =>
    timeStamp = dateString.slice(6, dateString.length-2)
    timeStamp = parseInt(timeStamp)
    return new Date(timeStamp)



  encodeFile: (buffer) =>
    base64 = buffer.toString('base64')
    return "/File(#{base64})/"



  decodeFile: (fileString) =>
    base64 = fileString.slice(6, fileString.length-2)
    return new Buffer(base64, 'base64')



  callback: (ctx) =>
    service_name = @parseServiceName(ctx)
    ctx.body = await @callService(service_name, ctx.requestBody.data)



  parseServiceName: (ctx) =>
    return ctx.path.slice(1)
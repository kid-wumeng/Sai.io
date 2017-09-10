Koa        = require('koa')
bodyParser = require('koa-bodyparser')
error      = require('../error')



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



  __callService: (name, data) =>
    service = @services[name]
    if(service)
      return @call(service.io, data)
    else
      serviceNotFound({name})



  start: (message) =>
    @__useBodyParser()
    @__useCallback()
    @koa.listen(@port)

    message ?= "sai-io app:#{@port} start ~ !"
    console.log message.green



  __useBodyParser: =>
    @koa.use(bodyParser({
      enableTypes: ['json']
      # @TODO 可配置化
      jsonLimit: '5mb'
    }))



  __useCallback: =>
    @koa.use (ctx) =>
      service_name = ctx.path.slice(1)
      body = ctx.request.body
      ctx.body = await @__callService(service_name, body.data)
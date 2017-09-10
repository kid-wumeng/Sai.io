Koa   = require('koa')
error = require('../error')



ioNotFound = ({name}) ->
  error({
    code: 10001
    zh_message: "io [#{name}] 未找到，是不是没用app.io()注册？"
    data: {name}
  })



module.exports = class App



  constructor: (options={}) ->
    @port = options.port
    @ios  = {}
    @koa  = new Koa()



  config: (key, value) ->
    @[key] = value



  io: (name, fn) ->
    @ios[name] = fn



  call: (name, data={}) ->
    io = @ios[name]
    if(io)
      io(data)
    else
      ioNotFound({name})



  start: ->
    @koa.use (ctx) -> ctx.body = 123
    @koa.listen(@port)
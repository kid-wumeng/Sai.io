_        = require('lodash')
helper   = require('../helper')
errors   = require('../errors')
Store    = require('./Store')
Context  = require('./Context')
RPC      = require('./RPC')
REST     = require('./REST')
Server   = require('./Server')
Realtime = require('./Realtime')
Document = require('./Document')



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
    @store    = new Store()
    @context  = new Context(@store)
    @doc      = new Document(@store)
    @rpc      = new RPC(@store)
    @rest     = new REST(@store)
    @server   = new Server(@rpc, @rest, @doc)
    @realtime = new Realtime(@store, @server)



  io: (args...) =>
    @store.io(args...)


  method: (args...) =>
    @store.method(args...)


  get: (args...) =>
    @store.get(args...)


  topic: (args...) =>
    @store.topic(args...)


  mount: (args...) =>
    @store.mount(args...)



  ### @Public ###
  # 本地调用io
  ##
  call: (name, params...) =>
    io = @ios[name]
    if io
      ctx = @formatContext({})
      return io.call(ctx, params)
    else
      throw errors.IO_NOT_FOUND(name)


  ### @Public ###
  # 本地发布实时消息
  ##
  publish: (topic, params...) =>
    @realtime.publish(topic, params)



  ### @Private ###
  formatContext: (ctx) =>
    return Context.format(ctx, {
      ios: @ios
      mount: @mount
    })



  ### @Public ###
  # 开始监听端口
  ##
  listen: (port=80) =>
    @server.listen(port)
    console.log "sai-io app:#{port} start ~ !".green
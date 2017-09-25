Client   = require('./Client')
Store    = require('./Store')
RPC      = require('./RPC')
REST     = require('./REST')
Realtime = require('./Realtime')



module.exports = class RemoteApp


  ### options ###
  # {number} timeout              - http 与 web-socket 请求超时时间，单位毫秒
  # {number} reconnectInterval    - web-socket 初始重连间隔，单位毫秒
  # {number} reconnectIntervalMax - web-socket 最大重连间隔，单位毫秒，即衰退极限
  # {number} reconnectDecay       - web-socket 重连衰退常数
  ##
  constructor: (url, options={}) ->
    options = Object.assign({
      timeout:              30000
      reconnectInterval:    1000
      reconnectIntervalMax: 30000
      reconnectDecay:       1.5
    }, options)

    @client   = new Client(url, RemoteApp.adapter, options)
    @store    = new Store()
    @rpc      = new RPC(@client, @store)
    @rest     = new REST(@client, @store)
    @realtime = new Realtime(@client, @store)


  call: (method, params...) ->
    return @rpc.call(method, params)



  callBatch: (tasks) ->
    return @rpc.callBatch(tasks)



  callSeq: (tasks) ->
    return @rpc.callSeq(tasks)



  callParal: (tasks) ->
    return @rpc.callParal(tasks)



  get: (path) ->
    return @rest.get(path)



  task: (method, params...) =>
    return @rpc.task(method, params)



  done: (callback) =>
    @store.done(callback)
    return @



  fail: (callback) =>
    @store.fail(callback)
    return @



  subscribe: (topic, callback) ->
    @store.subscribe(topic, callback)



  on: (event, callback) ->
    if not ['open', 'close', 'error'].includes(event)
      throw 'Sorry, your only listen the {open}, {close} or {error} event.'

    @client.on(event, callback)
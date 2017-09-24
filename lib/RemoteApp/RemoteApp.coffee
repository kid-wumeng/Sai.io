Client = require('./Client')
RPC    = require('./RPC')



module.exports = class RemoteApp


  ### options ###
  # {number} timeout              - http 与 web-socket 请求超时时间，单位毫秒
  # {number} reconnectInterval    - web-socket 初始重连间隔，单位毫秒
  # {number} reconnectIntervalMax - web-socket 最大重连间隔，单位毫秒，即衰退极限
  # {number} reconnectDecay       - web-socket 重连衰退常数
  ##
  constructor: (url, options={}) ->
    options = Object.assign({
      timeout:              10000
      reconnectInterval:    1000
      reconnectIntervalMax: 30000
      reconnectDecay:       1.5
    }, options)

    @client = new Client(url, RemoteApp.adapter, options)
    @rpc    = new RPC(@client)



  call: (method, params...) ->
    return @rpc.call(method, params)



  callBatch: (tasks) ->
    return @rpc.callBatch(tasks)



  callSeq: (tasks) ->
    return @rpc.callSeq(tasks)



  callParal: (tasks) ->
    return @rpc.callParal(tasks)



  task: (method, params...) =>
    return @rpc.task(method, params)



  on: (event, callback) ->
    if not ['open', 'close', 'error'].includes(event)
      throw 'Sorry, your only listen the {open}, {close} or {error} event.'

    @client.on(event, callback)
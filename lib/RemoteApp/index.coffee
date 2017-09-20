Client = require('./Client')
RPC    = require('./RPC')



module.exports = class RemoteApp


  constructor: (url, options={}) ->
    @client = new Client(url)
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
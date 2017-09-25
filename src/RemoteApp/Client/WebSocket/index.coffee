EventBus   = require('./EventBus')
Socket     = require('./Socket')
PostOffice = require('./PostOffice')


### WebSocket ###
#
# JSON-RPC request ===>>
# message:
#   stamp: 'uuidv4'
#   packet:
#     type: 'json-rpc'
#     task:
#       json-rpc: '2.0'
#       method: 'login'
#       params: [email, password]
#       id: 'uuidv4'
#
#
# <<=== JSON-RPC response
# message:
#   stamp: 'uuidv4'
#   packet:
#     json-rpc: '2.0'
#     result: {...}
#     error: {...}
#     id: 'uuidv4'
#
#
# JSON-RPC request ( batch ) ===>>
# message:
#   stamp: 'uuidv4'
#   packet:
#     type: 'json-rpc'
#     batch: true
#     tasks: [{
#       json-rpc: '2.0'
#       method: 'login'
#       params: [email, password]
#       id: 'uuidv4'
#     }, ...]
#
#
# <<=== JSON-RPC request ( batch )
# message:
#   stamp: 'uuidv4'
#   packet: [{
#     json-rpc: '2.0'
#     result: {...}
#     error: {...}
#     id: 'uuidv4'
#   }, ...]
#
#
# REST request ===>>
# message:
#   stamp: 'uuidv4'
#   packet:
#     type: 'rest'
#     task:
#       method: 'POST'
#       path: 'users/:id'
#       data: {...}
#
#
# <<=== REST response
# message:
#   stamp: 'uuidv4'
#   packet:
#     result: {...}
#     error: {...}
#
#
# subscribe request ===>>
# 待定
#
#
# <<=== publish response
# message:
#   topic: 'notify'
#   params: [6, 'hello ~']
##


module.exports = class WebSocket

  constructor: (url, adapter, options) ->
    @eventBus   = new EventBus()
    @socket     = new Socket(url, adapter, options, @eventBus)
    @postOffice = new PostOffice(adapter, options, @socket, @eventBus)


  send: (packet, complete, timeout) ->
    @postOffice.send(packet, complete, timeout)


  on: (event, callback) ->
    @eventBus.on(event, callback)
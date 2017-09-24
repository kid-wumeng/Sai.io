EventBus   = require('./EventBus')
Socket     = require('./Socket')
PostOffice = require('./PostOffice')



module.exports = class WebSocket

  constructor: (url, adapter, options) ->
    @eventBus   = new EventBus()
    @socket     = new Socket(url, adapter, options, @eventBus)
    @postOffice = new PostOffice(adapter, options, @socket, @eventBus)


  send: (packet, complete, timeout) ->
    @postOffice.send(packet, complete, timeout)


  on: (event, callback) ->
    @eventBus.on(event, callback)
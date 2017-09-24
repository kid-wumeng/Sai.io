EventBus   = require('./EventBus')
Socket     = require('./Socket')
PostOffice = require('./PostOffice')



module.exports = class WebSocket

  constructor: (url, adapter, options) ->
    @eventBus   = new EventBus()
    @socket     = new Socket(url, adapter, options, @eventBus)
    @postOffice = new PostOffice(adapter, @socket, @eventBus)


  send: (packet, callback) ->
    @postOffice.send(packet, callback)


  on: (event, callback) ->
    @eventBus.on(event, callback)
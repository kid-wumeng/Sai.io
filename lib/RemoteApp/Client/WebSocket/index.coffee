Socket     = require('./Socket')
PostOffice = require('./PostOffice')



module.exports = class WebSocket

  constructor: (url, adapter, options) ->
    @eventCenter = new EventCenter()
    @socket      = new Socket(url, adapter, options, @eventCenter)
    @postOffice  = new PostOffice(adapter, @socket, @eventCenter)


  send: (packet, callback) ->
    @postOffice.send(packet, callback)


  on: (event, callback) ->
    @eventCenter.on(event, callback)
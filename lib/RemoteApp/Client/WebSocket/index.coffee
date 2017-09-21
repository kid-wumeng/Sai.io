Socket     = require('./Socket')
PostOffice = require('./PostOffice')



module.exports = class WebSocket

  constructor: (url, adapter) ->
    @socket     = new Socket(url, adapter)
    @postOffice = new PostOffice(@socket, adapter)


  send: (packet, callback) ->
    @postOffice.send(packet, callback)
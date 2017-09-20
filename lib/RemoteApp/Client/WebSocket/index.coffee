Socket     = require('./Socket')
PostOffice = require('./PostOffice')



module.exports = class WebSocket

  constructor: (url) ->
    @socket     = new Socket(url)
    @postOffice = new PostOffice(@socket)


  send: (packet, callback) ->
    @postOffice.send(packet, callback)
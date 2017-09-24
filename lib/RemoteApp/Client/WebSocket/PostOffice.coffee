uuidv4  = require('uuid/v4')
SaiJSON = require('../../../assets/SaiJSON')



module.exports = class PostOffice


  constructor: (adapter, socket, eventCenter) ->
    @saiJSON     = new SaiJSON(adapter)
    @socket      = socket
    @eventCenter = eventCenter
    @dict        = {}

    @eventCenter.on('message', @receive)



  send: (packet, callback) =>
    @saiJSON.encode packet, =>
      {stamp, message} = @seal(packet)
      @dict[stamp] = callback
      @socket.send(message)



  seal: (packet, callback) =>
    stamp   = uuidv4()
    message = {stamp, packet}
    message = JSON.stringify(message)
    return {stamp, message}



  receive: (message) =>
    {stamp, packet} = @unseal(message)
    callback = @dict[stamp]
    if callback
      delete @dict[stamp]
      @saiJSON.decode packet, => callback(packet)



  unseal: (message) =>
    message = JSON.parse(message)
    {stamp, packet} = message
    return {stamp, packet}
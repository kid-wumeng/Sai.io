uuidv4 = require('uuid/v4')
helper = require('../../../helper')



module.exports = class PostOffice


  constructor: (socket) ->
    @socket = socket
    @dict   = {}

    @socket.on('message', @receive)



  send: (packet, callback) =>
    {stamp, message} = @seal(packet)
    @dict[stamp] = callback
    @socket.send(message)



  seal: (packet) =>
    helper.encodeBody(packet)
    stamp   = uuidv4()
    message = {stamp, packet}
    message = JSON.stringify(message)
    return {stamp, message}



  receive: (message) =>
    {stamp, packet} = @unseal(message)
    callback = @dict[stamp]

    if callback
      delete @dict[stamp]
      callback(packet)



  unseal: (message) =>
    message = JSON.parse(message)
    {stamp, packet} = message
    helper.decodeBody(packet)
    return {stamp, packet}
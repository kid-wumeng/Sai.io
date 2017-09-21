CodeTask = require('./CodeTask')


module.exports = class SaiJSON

  constructor: (adapter) ->
    @adapter = adapter



  encode: (packet, onComplete) =>
    new CodeTask(@adapter, packet, onComplete).encode()



  decode: (packet, onComplete) =>
    new CodeTask(@adapter, packet, onComplete).decode()
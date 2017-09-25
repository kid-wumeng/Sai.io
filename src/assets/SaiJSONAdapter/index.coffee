### SaiJSON 适配器 for NodeJS ###



exports.isFile = (value) ->
  return value instanceof Buffer



exports.encodeFile = (buffer, callback) ->
  base64 = buffer.toString('base64')
  fileString = "/File(#{base64})/"
  callback(fileString)



exports.decodeFile = (fileString, callback) ->
  base64 = fileString.slice(6, fileString.length-2)
  buffer = new Buffer(base64, 'base64')
  callback(buffer)
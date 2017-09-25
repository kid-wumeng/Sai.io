RemoteApp = require('./RemoteApp')
RemoteApp.adapter = {}



RemoteApp.adapter.isFile = (value) ->
  return value instanceof File



RemoteApp.adapter.encodeFile = (file, callback) ->
  reader = new FileReader()
  reader.addEventListener 'load', ->
    dataUrl = reader.result
    base64 = dataUrl.replace(/^data:.*;base64,/, '')
    fileString = "/File(#{base64})/"
    callback(fileString)
  reader.readAsDataURL(file)



RemoteApp.adapter.decodeFile = (fileString, callback) ->
  base64 = fileString.slice(6, fileString.length-2)
  callback(base64)



Sai = { RemoteApp }
module.exports = Sai
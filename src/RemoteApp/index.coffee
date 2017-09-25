SaiJSONAdapter = require('../assets/SaiJSONAdapter')
RemoteApp      = require('./RemoteApp')



RemoteApp.adapter = {}
RemoteApp.adapter.isFile     = SaiJSONAdapter.isFile
RemoteApp.adapter.encodeFile = SaiJSONAdapter.encodeFile
RemoteApp.adapter.decodeFile = SaiJSONAdapter.decodeFile



module.exports = RemoteApp
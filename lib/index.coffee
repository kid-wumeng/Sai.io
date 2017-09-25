require('colors')
globalEventBus = require('./assets/globalEventBus')


exports.App       = require('./App')
exports.RemoteApp = require('./RemoteApp')
exports.Schema    = require('./Schema')
exports.Code      = require('./Code')
exports.MongoDB   = require('./MongoDB')
exports.Redis     = require('./Redis')


exports.catch = (callback) => globalEventBus.on('error', callback)
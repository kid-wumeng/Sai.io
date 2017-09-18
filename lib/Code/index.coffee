JSONWebToken = require('./JSONWebToken')



module.exports = class Code

  constructor: ->
    @jwt = new JSONWebToken()
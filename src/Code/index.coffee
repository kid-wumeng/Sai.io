JSONWebToken = require('./JSONWebToken')
Bcrypt       = require('./Bcrypt')


module.exports = class Code
  constructor: ->
    @jwt    = new JSONWebToken()
    @bcrypt = new Bcrypt()
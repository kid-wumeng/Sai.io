jwt    = require('jsonwebtoken')
errors = require('../errors')



module.exports = class JSONWebToken



  encode: (payload, secret, maxAge) =>
    return jwt.sign(payload, secret, maxAge)



  decode: (token, secret) =>
    try
      return jwt.verify(token, secret)
    catch error
      throw errors.INVALID_TOKEN(token)
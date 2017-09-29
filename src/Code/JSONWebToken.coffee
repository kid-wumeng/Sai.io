jwt    = require('jsonwebtoken')
errors = require('../errors')


module.exports = class JSONWebToken


  encode: (payload, secret, maxAge=0) =>
    return jwt.sign(payload, secret, {
      expiresIn: maxAge
    })


  decode: (token, secret) =>
    try
      return jwt.verify(token, secret)
    catch error
      throw errors.INVALID_TOKEN(token)
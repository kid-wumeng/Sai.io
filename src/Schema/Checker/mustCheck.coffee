_      = require('lodash')
errors = require('../../errors')


module.exports = (value, message) ->
  if _.isNil(value)
    message ?= "Sorry, the value is required."
    throw errors.VALIDATION_FAILED(message)
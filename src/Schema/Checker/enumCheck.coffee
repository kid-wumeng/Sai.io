_      = require('lodash')
errors = require('../../errors')


module.exports = (value, enums, message) ->
  if value?
    if !enums.includes(value)
      message ?= "Sorry, the value should in [#{enums.join(', ')}]."
      throw errors.VALIDATION_FAILED(message, {current: value})
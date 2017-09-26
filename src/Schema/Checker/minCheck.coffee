_      = require('lodash')
errors = require('../../errors')


module.exports = (value, min, message) ->
  if value?
    switch
      when _.isString(value) and value.length < min
        message ?= "Sorry, the value(string)'s length should ≥ #{min}."
        throw errors.VALIDATION_FAILED(message, {current: value, currentLength: value.length})

      when _.isNumber(value) and value < min
        message ?= "Sorry, the value(number) should ≥ #{min}."
        throw errors.VALIDATION_FAILED(message, {current: value})

      when (value instanceof Date) and value.getTime() < min.getTime()
        message ?= "Sorry, the value(Date) should ≥ #{min.toLocaleString()}."
        throw errors.VALIDATION_FAILED(message, {current: value.toLocaleString()})

      when (value instanceof Buffer) and value.length < min
        message ?= "Sorry, the value(Buffer)'s length should ≥ #{min}."
        throw errors.VALIDATION_FAILED(message, {current: value, currentLength: value.length})

      else
        message ?= "Sorry, the value(#{value.constructor.name}) can't check min-value."
        throw errors.VALIDATION_FAILED(message, {current: value})
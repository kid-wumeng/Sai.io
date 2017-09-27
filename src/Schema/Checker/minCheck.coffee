_      = require('lodash')
assets = require('../../assets')
errors = require('../../errors')


module.exports = (value, min, message) ->
  if value?
    switch
      when _.isString(value)
        if assets.lenString(value) < min
          message ?= "Sorry, the value(string)'s length should ≥ #{min}."
          throw errors.VALIDATION_FAILED(message, {current: value, currentLength: assets.lenString(value)})

      when _.isNumber(value)
        if value < min
          message ?= "Sorry, the value(number) should ≥ #{min}."
          throw errors.VALIDATION_FAILED(message, {current: value})

      when value instanceof Date
        if value.getTime() < min.getTime()
          message ?= "Sorry, the value(Date) should ≥ #{min.toLocaleString()}."
          throw errors.VALIDATION_FAILED(message, {current: value.toLocaleString()})

      when value instanceof Buffer
        if value.length < min
          message ?= "Sorry, the value(Buffer)'s length should ≥ #{min}."
          throw errors.VALIDATION_FAILED(message, {current: value, currentLength: value.length})

      else
        message ?= "Sorry, the value(#{value.constructor.name}) can't check min-value."
        throw errors.VALIDATION_FAILED(message, {current: value})
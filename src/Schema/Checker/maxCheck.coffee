_      = require('lodash')
assets = require('../../assets')
errors = require('../../errors')


module.exports = (value, max, message) ->
  if value?
    switch
      when _.isString(value)
        if assets.lenString(value) > max
          message ?= "Sorry, the value(string)'s length should ≤ #{max}."
          throw errors.VALIDATION_FAILED(message, {current: value, currentLength: assets.lenString(value)})

      when _.isNumber(value)
        if value > max
          message ?= "Sorry, the value(number) should ≤ #{max}."
          throw errors.VALIDATION_FAILED(message, {current: value})

      when value instanceof Date
        if value.getTime() > max.getTime()
          message ?= "Sorry, the value(Date) should ≤ #{max.toLocaleString()}."
          throw errors.VALIDATION_FAILED(message, {current: value.toLocaleString()})

      when value instanceof Buffer
        if value.length > max
          message ?= "Sorry, the value(Buffer)'s length should ≤ #{max}."
          throw errors.VALIDATION_FAILED(message, {current: value, currentLength: value.length})

      else
        message ?= "Sorry, the value(#{value.constructor.name}) can't check max-value."
        throw errors.VALIDATION_FAILED(message, {current: value})
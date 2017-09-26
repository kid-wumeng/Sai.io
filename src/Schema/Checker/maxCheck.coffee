_      = require('lodash')
errors = require('../../errors')


module.exports = (value, max, message) ->
  if value?
    switch
      when _.isString(value) and value.length > max
        message ?= "Sorry, the value(string)'s length should ≤ #{max}."
        throw errors.VALIDATION_FAILED(message, {current: value, currentLength: value.length})

      when _.isNumber(value) and value > max
        message ?= "Sorry, the value(number) should ≤ #{max}."
        throw errors.VALIDATION_FAILED(message, {current: value})

      when (value instanceof Date) and value.getTime() > max.getTime()
        message ?= "Sorry, the value(Date) should ≤ #{max.toLocaleString()}."
        throw errors.VALIDATION_FAILED(message, {current: value.toLocaleString()})

      when (value instanceof Buffer) and value.length > max
        message ?= "Sorry, the value(Buffer)'s length should ≤ #{max}."
        throw errors.VALIDATION_FAILED(message, {current: value, currentLength: value.length})

      else
        message ?= "Sorry, the value(#{value.constructor.name}) can't check max-value."
        throw errors.VALIDATION_FAILED(message, {current: value})
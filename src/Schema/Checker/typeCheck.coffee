_      = require('lodash')
errors = require('../../errors')


module.exports = (value, type, message) ->
  if value?
    switch
      when type is Boolean
        if !_.isBoolean(value)
          message ?= "Sorry, the value's type should be boolean."
          throw errors.VALIDATION_FAILED(message, {current: value})

      when type is Number
        if !_.isFinite(value)
          message ?= "Sorry, the value's type should be number."
          throw errors.VALIDATION_FAILED(message, {current: value})

      when type is String
        if !_.isString(value)
          message ?= "Sorry, the value's type should be string."
          throw errors.VALIDATION_FAILED(message, {current: value})

      when type is Object
        if !_.isPlainObject(value)
          message ?= "Sorry, the value's type should be plain-object."
          throw errors.VALIDATION_FAILED(message, {current: value})

      else
        if !(value instanceof type)
          message ?= "Sorry, the value's type should be #{type.name}."
          throw errors.VALIDATION_FAILED(message, {current: value})
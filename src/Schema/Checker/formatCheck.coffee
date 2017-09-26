_      = require('lodash')
errors = require('../../errors')


module.exports = (store, value, formats, message) ->
  if value?
    if _.isString(formats)
      formats = [formats]

    for name in formats
      format = store.formats[name]
      if !format
        throw errors.FORMAT_NOT_FOUND(name)
      if format.check(value)
        return

    message ?= "Sorry, the value's format should in [#{formats.join(', ')}]."
    throw errors.VALIDATION_FAILED(message, {current: value})
_        = require('lodash')
fileType = require('file-type')
errors   = require('../../errors')


module.exports = (value, mimes, message) ->
  if value?
    if _.isString(mimes)
      mimes = [mimes]

    mime = fileType(value).mime
    if !mimes.includes(mime)
      message ?= "Sorry, the value's mime should in [#{mimes.join(', ')}]."
      throw errors.VALIDATION_FAILED(message, {current: mime})
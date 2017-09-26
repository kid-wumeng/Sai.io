module.exports = (message, data) =>
  error        = new Error(message)
  error.status = 400
  error.code   = 'VALIDATION_FAILED'
  error.data   = data
  return error
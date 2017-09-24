module.exports = =>
  error        = new Error("Sorry, the request timeout.")
  error.status = 408
  error.code   = 'REQUEST_TIMEOUT'
  return error
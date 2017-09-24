module.exports = =>
  error        = new Error("Sorry, the request failed.")
  error.status = 500
  error.code   = 'UNKNOWN_NETWORK_STATUS'
  return error
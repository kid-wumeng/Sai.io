module.exports = =>
  error        = new Error("Sorry, the request failed, pleace to check the network or server.")
  error.status = 500
  error.code   = 'BAD_NETWORK'
  return error
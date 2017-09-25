module.exports = (token) =>
  error        = new Error("Sorry, your token is invalid.")
  error.status = 401
  error.code   = 'INVALID_TOKEN'
  error.data   = {token}
  return error
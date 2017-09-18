module.exports = (name) =>
  error        = new Error("Sorry, the method {#{name}} is not found.")
  error.status = 404
  error.code   = 'METHOD_NOT_FOUND'
  error.data   = {method: name}
  return error
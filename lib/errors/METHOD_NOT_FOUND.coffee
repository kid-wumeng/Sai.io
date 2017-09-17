module.exports = (name) =>
  error = new Error("method not found: #{name}")
  error.status = 404
  error.code = 'METHOD_NOT_FOUND'
  error.data = {method: name}
  return error
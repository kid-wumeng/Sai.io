module.exports = ( method, path ) =>
  error        = new Error("Sorry, the route { #{method}: '#{path}' } is not found.")
  error.status = 404
  error.code   = 'ROUTE_NOT_FOUND'
  error.data   = { method, path }
  return error
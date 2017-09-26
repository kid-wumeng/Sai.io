module.exports = (name) =>
  error        = new Error("Sorry, the format { #{name} } is not found.")
  error.status = 404
  error.code   = 'FORMAT_NOT_FOUND'
  error.data   = {format: name}
  return error
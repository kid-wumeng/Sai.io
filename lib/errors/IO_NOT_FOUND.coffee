module.exports = (name) =>
  error = new Error("io not found: #{name}")
  error.status = 404
  error.code = 'IO_NOT_FOUND'
  error.data = {io: name}
  return error
module.exports = (name) =>
  error        = new Error("Sorry, the io {#{name}} is not found")
  error.status = 404
  error.code   = 'IO_NOT_FOUND'
  error.data   = {io: name}
  return error
module.exports = (name) =>
  error        = new Error("Sorry, the event { #{name} } is not found.")
  error.status = 404
  error.code   = 'EVENT_NOT_FOUND'
  error.data   = {event: name}
  return error
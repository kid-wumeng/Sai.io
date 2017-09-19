module.exports = (name) =>
  error        = new Error("Sorry, the topic { #{name} } is not found.")
  error.status = 404
  error.code   = 'TOPIC_NOT_FOUND'
  error.data   = {topic: name}
  return error
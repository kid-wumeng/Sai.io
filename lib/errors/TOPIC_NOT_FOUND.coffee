module.exports = (topic) =>
  error        = new Error("Sorry, the topic { #{topic.name} } is not found.")
  error.status = 404
  error.code   = 'TOPIC_NOT_FOUND'
  error.data   = {topic: topic.name}
  return error
module.exports = (name) =>
  error        = new Error("Sorry, the rule { #{name} } is not found.")
  error.status = 404
  error.code   = 'RULE_NOT_FOUND'
  error.data   = {rule: name}
  return error
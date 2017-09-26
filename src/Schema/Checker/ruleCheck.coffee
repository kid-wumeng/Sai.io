_      = require('lodash')
errors = require('../../errors')


module.exports = (store, value, name) ->
  rule = store.rules[name]
  if !rule
    throw errors.RULE_NOT_FOUND(name)

  try
    rule.check(value)
  catch error
    error.message = "{{ #{name} }} #{error.message}"
    throw error
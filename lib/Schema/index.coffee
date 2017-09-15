_       = require('lodash')
Checker = require('./Checker')



module.exports = class Schema

  constructor: (options={}) ->
    @rules = {}



  ### @PUBLIC ###
  # 包装数据
  ##
  check: (data, path) =>
    if(path)
      value = _.get(data, path)
    else
      value = data

    return new Checker({
      value: value
      rules: @rules
    })



  ### @PUBLIC ###
  # 制定规则
  ##
  rule: (name, callback) =>
    @rules[name] = callback
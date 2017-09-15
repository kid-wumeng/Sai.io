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
      data = _.get(data, path)
    return new Checker({
      data: data
      rules: @rules
    })



  ### @PUBLIC ###
  # 制定规则
  ##
  rule: (name, callback) =>
    throw new Error('自定义异常')
    @rules[name] = callback
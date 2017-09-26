Store   = require('./Store')
Checker = require('./Checker')


module.exports = class Schema

  constructor: (options={}) ->
    @store = new Store()


  ### @Public ###
  # 验证数据
  ##
  check: (data, path) =>
    return new Checker(@store, data, path)


  ### @Public ###
  # 定制规则
  ##
  rule: (name, check) =>
    @store.rule(name, check)
    return @


  ### @Public ###
  # 定制格式
  ##
  format: (name, check) =>
    @store.format(name, check)
    return @
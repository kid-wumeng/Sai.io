_       = require('lodash')
Store   = require('./Store')
Checker = require('./Checker')


module.exports = class Schema

  constructor: (options={}) ->
    @store = new Store()


  ### @Public ###
  # 验证数据
  ##
  check: (datas, path) =>
    return new Checker(@store, datas, path)



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



  ### @Public ###
  # 挑选属性
  ##
  pick: (datas=[], keys=[]) =>
    if _.isString(keys)
      keys = keys.split(/\s+/)

    if Array.isArray(datas)
      return datas.map (data) -> _.pick(data, keys)
    else
      data = datas
      return _.pick(data, keys)



  ### @Public ###
  # 排除属性
  ##
  omit: (datas=[], keys=[]) =>
    if _.isString(keys)
      keys = keys.split(/\s+/)

    if Array.isArray(datas)
      return datas.map (data) -> _.omit(data, keys)
    else
      data = datas
      return _.omit(data, keys)
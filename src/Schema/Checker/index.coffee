_           = require('lodash')
mustCheck   = require('./mustCheck')
typeCheck   = require('./typeCheck')
enumCheck   = require('./enumCheck')
minCheck    = require('./minCheck')
maxCheck    = require('./maxCheck')
mimeCheck   = require('./mimeCheck')
formatCheck = require('./formatCheck')
ruleCheck   = require('./ruleCheck')


module.exports = class Checker

  constructor: (store, data, path) ->
    @store = store
    @data  = data
    @path  = path
    @value = if path then _.get(data, path) else data


  ### @Public ###
  # 存在性验证
  ##
  must: (message) =>
    mustCheck(@value, message)
    return @


  ### @Public ###
  # 类型验证
  ##
  type: (type, message) =>
    typeCheck(@value, type, message)
    return @


  ### @Public ###
  # 枚举验证
  ##
  enum: (enums, message) =>
    enumCheck(@value, enums, message)
    return @


  ### @Public ###
  # 最小值验证
  ##
  min: (min, message) =>
    minCheck(@value, min, message)
    return @


  ### @Public ###
  # 最大值验证
  ##
  max: (max, message) =>
    maxCheck(@value, min, message)
    return @


  ### @Public ###
  # MIME验证
  ##
  mime: (mimes, message) =>
    mimeCheck(@value, mimes, message)
    return @


  ### @Public ###
  # 格式验证
  ##
  format: (formats, message) =>
    formatCheck(@store, @value, formats, message)
    return @


  ### @Public ###
  # 规则集验证
  ##
  rule: (name) =>
    ruleCheck(@store, @value, name)
    return @
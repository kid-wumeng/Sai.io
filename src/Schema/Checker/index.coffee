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

  constructor: (store, datas, path) ->
    @store = store
    @datas = if Array.isArray(datas) then datas else [datas]
    @path  = path

    if(@path)
      @values = @datas.map (data) -> _.get(data, path)
    else
      @values = @datas



  ### @Public ###
  # 存在性验证
  ##
  must: (message) =>
    for value in @values
      mustCheck(value, message)
    return @



  ### @Public ###
  # 类型验证
  ##
  type: (type, message) =>
    for value in @values
      typeCheck(value, type, message)
    return @



  ### @Public ###
  # 枚举验证
  ##
  enum: (enums, message) =>
    for value in @values
      enumCheck(value, enums, message)
    return @



  ### @Public ###
  # 最小值验证
  ##
  min: (min, message) =>
    for value in @values
      minCheck(value, min, message)
    return @



  ### @Public ###
  # 最大值验证
  ##
  max: (max, message) =>
    for value in @values
      maxCheck(value, max, message)
    return @



  ### @Public ###
  # MIME验证
  ##
  mime: (mimes, message) =>
    for value in @values
      mimeCheck(value, mimes, message)
    return @



  ### @Public ###
  # 格式验证
  ##
  format: (formats, message) =>
    for value in @values
      formatCheck(@store, value, formats, message)
    return @



  ### @Public ###
  # 规则集验证
  ##
  rule: (name) =>
    for value in @values
      ruleCheck(@store, value, name)
    return @
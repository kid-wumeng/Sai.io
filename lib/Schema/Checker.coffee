_      = require('lodash')
helper = require('../helper')
error  = require('./error')


module.exports = class Checker

  constructor: (options={}) ->
    @value = options.value
    @rules = options.rules ? {}



  ### @PUBLIC ###
  # 存在性验证
  ##
  must: (message) =>
    if _.isNil(@value)
      error.Check_Must_Failure({value: @value}, message)
    return @



  ### @PUBLIC ###
  # 最小值验证
  ##
  min: (min, message) =>
    switch
      when _.isString(@value) then @minString(min, message)
      when _.isNumber(@value) then @minNumber(min, message)
    return @

  minNumber: (min, message) =>
    if(@value < min)
      error.Check_Number_Min_Failure({value: @value, min}, message)

  minString: (min, message) =>
    size = @value.length
    if(size < min)
      error.Check_String_Min_Failure({value: @value, size, min}, message)



  ### @PUBLIC ###
  # 最大值验证
  ##
  max: (max, message) =>
    switch
      when _.isString(@value) then @maxString(max, message)
      when _.isNumber(@value) then @maxNumber(max, message)
    return @

  maxNumber: (max, message) =>
    if(@value > max)
      error.Check_Number_Max_Failure({value: @value, max}, message)

  maxString: (max, message) =>
    size = @value.length
    if(size > max)
      error.Check_String_Max_Failure({value: @value, size, max}, message)



  ### @PUBLIC ###
  # 规则集验证
  ##
  rule: (name) =>
    callback = @rules[name]
    if !callback
      ruleNotFound({name})
    try
      callback(@value)
    catch error
      error.message = "#{name}: #{error.message}"
      throw error



  throw: ({code, message, zh_message, en_message, info}) =>
    if _.isFunction(message)
      message = message(info ? {})

    helper.throw({
      status: 400
      code: code
      message: message
      zh_message: zh_message
      en_message: en_message
      info: info
    })



###
# 异常处理方法
###
ruleNotFound = ({name}) =>
  helper.throw({
    status: 404
    code: 10001
    zh_message: "规则 #{name} 未找到，是不是没用 schema.rule() 注册？"
    info: {name}
  })
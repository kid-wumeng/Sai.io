_      = require('lodash')
helper = require('../helper')



module.exports = class Checker

  constructor: (options={}) ->
    @data  = options.data
    @rules = options.rules ? {}



  ### @PUBLIC ###
  # 存在性验证
  ##
  must: (message) =>
    if _.isNil(@data)
      @throw({
        code: 10001
        message: message
        zh_message: "不能为空，当前：#{@data}"
        info: {data: @data}
      })
    return @



  ### @PUBLIC ###
  # 最小值验证
  ##
  min: (min, message) =>
    switch
      when _.isString(@data)
        hint = '字太少'
        size = @data.length

    if(size < min)
      @throw({
        code: 10001
        message: message
        zh_message: "#{hint}，当前=#{size}, min=#{min}"
        info: {data: @data, min, size}
      })

    return @



  ### @PUBLIC ###
  # 规则集验证
  ##
  rule: (name) =>
    callback = @rules[name]
    if !callback
      ruleNotFound({name})
    try
      callback(@data)
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
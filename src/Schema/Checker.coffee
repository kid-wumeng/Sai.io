_        = require('lodash')
fileType = require('file-type')
helper   = require('../helper')
error    = require('./error')


module.exports = class Checker

  constructor: (options={}) ->
    @value   = options.value
    @rules   = options.rules   ? {}
    @formats = options.formats ? {}
    @schema  = options.schema



  ### @Public ###
  # 存在性验证
  ##
  must: (message) =>
    if _.isNil(@value)
      error.Check_Must_Failure({ value: @value }, message)
    return @



  ### @Public ###
  # 类型验证
  ##
  type: (type, message) =>
    value = @value
    switch
      when type is Boolean and !_.isBoolean(value)     then fail = true
      when type is Number  and !_.isFinite(value)      then fail = true
      when type is String  and !_.isString(value)      then fail = true
      when type is Object  and !_.isPlainObject(value) then fail = true
      else
        if !(value instanceof type) then fail = true
    if fail
      error.Check_Type_Failure({ value, type }, message)
    return @



  ### @Public ###
  # 枚举验证
  ##
  enum: (enums, message) =>
    if !enums.includes(@value)
      error.Check_Enum_Failure({ value: @value, enums }, message)
    return @



  ### @Public ###
  # 最小值验证
  ##
  min: (min, message) =>
    value = @value
    switch
      when _.isString(value)       then @minString(value, min, message)
      when _.isNumber(value)       then @minNumber(value, min, message)
      when value instanceof Buffer then @minBuffer(value, min, message)
      when value instanceof Date   then @minDate(value, min, message)
    return @


  minNumber: (value, min, message) =>
    if(value < min)
      error.Check_Number_Min_Failure({ value, min }, message)


  minString: (value, min, message) =>
    size = @schema.lenString(value)
    if(size < min)
      error.Check_String_Min_Failure({ value, size, min }, message)


  minBuffer: (value, min, message) =>
    size = @schema.lenString(value)
    if(size < min)
      error.Check_Buffer_Min_Failure({ value, size, min }, message)


  minDate: (value, min, message) =>
    if(value.getTime() < min.getTime())
      error.Check_Date_Min_Failure({ value, min }, message)



  ### @Public ###
  # 最大值验证
  ##
  max: (max, message) =>
    value = @value
    switch
      when _.isString(value)       then @maxString(value, max, message)
      when _.isNumber(value)       then @maxNumber(value, max, message)
      when value instanceof Buffer then @maxBuffer(value, max, message)
      when value instanceof Date   then @maxDate(value, max, message)
    return @


  maxNumber: (value, max, message) =>
    if(value > max)
      error.Check_Number_Max_Failure({ value, max }, message)


  maxString: (value, max, message) =>
    size = value.length
    if(size > max)
      error.Check_String_Max_Failure({ value, size, max }, message)


  maxBuffer: (value, max, message) =>
    size = value.length
    if(size > max)
      error.Check_Buffer_Max_Failure({ value, size, max }, message)


  maxDate: (value, max, message) =>
    if(value.getTime() > max.getTime())
      error.Check_Date_Max_Failure({ value, max }, message)



  ### @Public ###
  # MIME验证
  ##
  mime: (mimes, message) =>
    mime = fileType(value).mime
    if !mimes.includes(mime)
      error.Check_MIME_Failure({ value, mime, mimes }, message)
    return @



  ### @Public ###
  # 格式验证
  ##
  format: (formats, message) =>
    if !Array.isArray(formats)
      formats = [formats]

    value = @value
    valid = false

    for name in formats
      format = @formats[name]
      if format(value)
        valid = true
        break

    if !valid
      error.Check_Format_Failure({ value, formats }, message)

    return @



  ### @Public ###
  # 规则集验证
  ##
  rule: (name) =>
    callback = @rules[name]
    if !callback then error.Rule_Not_Found({ ruleName: name })

    try
      await callback(@value)
    catch error
      # 加上规则集的名字后继续上抛异常
      error.message = "#{name}: #{error.message}"
      helper.throw(error)
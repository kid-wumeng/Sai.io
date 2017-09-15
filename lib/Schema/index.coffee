_       = require('lodash')
Checker = require('./Checker')



module.exports = class Schema

  constructor: (options={}) ->
    @rules   = {}
    @formats =
      email: @isEmail
      url:   @isUrl



  ### @PUBLIC ###
  # 定制规则
  ##
  rule: (name, callback) =>
    @rules[name] = callback



  ### @PUBLIC ###
  # 定制格式
  ##
  format: (name, callback) =>
    @formats[name] = callback



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
      formats: @formats
      schema: @
    })



  ### @PUBLIC ###
  # 统计字符串长度，单字节占1位，双字节占2位
  ##
  lenString: (string) =>
    doubleReg = /[^\x00-\xff]/
    len = 0
    for char in string
      len += if doubleReg.test(char) then 2 else 1
    return len



  ### @PUBLIC ###
  # 是否Email
  ##
  isEmail: (string) =>
    reg = /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/
    return reg.test(string)



  ### @PUBLIC ###
  # 是否URL
  ##
  isUrl: (string) =>
    reg = /(((^https?:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)$/
    return reg.test(string)
_ = require('lodash')



exports.error = (ctx, error) =>
  if _.isString(error)
    error = { message: error }

  keys  = ['code', 'message', 'data']
  error = _.pick(error, keys)

  error.ioChain = ctx.ioChain if ctx.ioChain.length
  error.ioStack = ctx.ioStack if ctx.ioStack.length
  error.method  = ctx.method  if ctx.method
  error.path    = ctx.path    if ctx.path

  return error



### @Public ###
# 异步睡眠
# 借助await即可实现同步睡眠
##
exports.sleep = (ms) =>
  return new Promise((resolve) => setTimeout(resolve, ms))



### @Public ###
# 统计字符串长度，单字节占1位，双字节占2位
##
exports.lenString = (string) =>
  doubleReg = /[^\x00-\xff]/
  len = 0
  for char in string
    len += if doubleReg.test(char) then 2 else 1
  return len



### @Public ###
# 是否Email
##
exports.isEmail = (string) =>
  reg = /^[a-z0-9]+([._\\-]*[a-z0-9])*@([a-z0-9]+[-a-z0-9]*[a-z0-9]+.){1,63}[a-z0-9]+$/
  return reg.test(string)



### @Public ###
# 是否URL
##
exports.isUrl = (string) =>
  reg = /(((^https?:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)$/
  return reg.test(string)
_ = require('lodash')



###
# 综合辅助工具库，放在这里的方法需满足2个基本条件：
# 1. 两个以上模块会用到
# 2. 弱逻辑：执行过程不依赖任何模块
#
# Sai的理念是模块之间无依存关系，即接近零耦合（app.mount可能是唯一的嵌合点）
# 但helper会供大多数模块使用，为了代码安全，这些方法严格设定为纯粹的静态方法
###



exports.overload = (args, types...) =>
  if args.length isnt types.length
    return false
  for type, i in types
    if not @instanceof(args[i], type)
      return false
  return true



exports.instanceof = (value, type) =>
  switch
    when type is Boolean then return _.isBoolean(value)
    when type is Number  then return _.isFinite(value)
    when type is String  then return _.isString(value)
    when type is Object  then return _.isPlainObject(value)
    else                      return value instanceof type
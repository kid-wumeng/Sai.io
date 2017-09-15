_      = require('lodash')
config = require('./config')



###
# 综合辅助工具库，放在这里的方法需满足2个基本条件：
# 1. 两个以上模块会用到
# 2. 弱逻辑：执行过程不依赖任何模块
#
# Sai的理念是模块之间无依存关系，即接近零耦合（app.mount可能是唯一的嵌合点）
# 但helper会供大多数模块使用，为了代码安全，这些方法严格设定为纯粹的静态方法
###



### @PUBLIC ###
# 抛出异常
# Sai系统层方案，以Sai标准封装error对象（兼容NodeJS原生error格式）
##
exports.throw = ({ status, code, message, en_message, zh_message, data }) =>
  message = i18n({
    message
    en_message
    zh_message
  })
  error = new Error(message)
  Object.assign(error, {
    status
    code
    data
  })
  throw error



# 根据language配置选择message
i18n = ({ message, en_message, zh_message }) =>
  if !message
    switch config.language
      when 'en' then message = en_message
      when 'zh' then message = zh_message
  return message ? ''



### @PUBLIC ###
# 异步睡眠
# 借助await即可实现同步睡眠
##
exports.sleep = (ms) =>
  return new Promise((resolve) => setTimeout(resolve, ms))



### @PUBLIC ###
# (深度优先)遍历一颗树的全部叶子节点
# callback(叶子key, 叶子value, 父节点parent)
##
exports.traverseTree = (tree, callback) ->
  traverseTreeEach(tree, null, null, callback)



traverseTreeEach = (node, key, parent, callback) ->
  # 嵌套对象
  if _.isPlainObject(node)
    for key, child of node
      traverseTreeEach(child, key, node, callback)
  # 数组
  else if Array.isArray(node)
    for child, i in node
      traverseTreeEach(child, i, node, callback)
  # 叶子节点
  else
    callback(node, key, parent)



### @PUBLIC ###
# 以Sai协议编码 请求体/响应体
# body是个json-object
# 直接改写原body，而不是返回新body
##
exports.encodeBody = (body) ->
  @traverseTree(body, encodeBodyEach)



encodeBodyEach = (value, key, parent) ->
  if value instanceof Date
    parent[key] = encodeDate(value)
  else if value instanceof Buffer
    parent[key] = encodeFile(value)



encodeDate = (date) ->
  timeStamp = date.getTime()
  return "/Date(#{timeStamp})/"



encodeFile = (buffer) ->
  base64 = buffer.toString('base64')
  return "/File(#{base64})/"



### @PUBLIC ###
# 以Sai协议解码 请求体/响应体
# body是个json-object
# 直接改写原body，而不是返回新body
##
exports.decodeBody = (body) ->
  @traverseTree(body, decodeBodyEach)



decodeBodyEach = (value, key, parent) ->
  dateRegExp = /^\/Date\(\d+\)\/$/
  fileRegExp = /^\/File\(.+\)\/$/

  if dateRegExp.test(value)
    parent[key] = decodeDate(value)

  else if fileRegExp.test(value)
    parent[key] = decodeFile(value)



decodeDate = (dateString) ->
  timeStamp = dateString.slice(6, dateString.length-2)
  timeStamp = parseInt(timeStamp)
  return new Date(timeStamp)



decodeFile = (fileString) ->
  base64 = fileString.slice(6, fileString.length-2)
  return new Buffer(base64, 'base64')
_ = require('lodash')



### @PUBLIC ###
##
exports.throw = ({status, code, message, en_message, zh_message, info, stack}) ->
  error            = new Error()
  error.bySai      = true
  error.status     = status     ? 500
  error.code       = code
  error.message    = message
  error.en_message = en_message
  error.zh_message = zh_message
  error.info       = info
  throw error



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
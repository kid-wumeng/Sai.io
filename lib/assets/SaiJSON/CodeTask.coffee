isPlainObject = require('lodash.isplainobject')



module.exports = class CodeTask

  constructor: (adapter, packet, onComplete) ->
    @isFile     = adapter.isFile
    @encodeFile = adapter.encodeFile
    @decodeFile = adapter.decodeFile
    @packet     = packet
    @onComplete = onComplete
    @isComplete = false
    @files      = []



  checkComplete: =>
    if @isComplete is false
      if @files.length is 0
        @isComplete = true
        @onComplete()



  encode: =>
    @traverse(@packet, @encodeEach)
    @checkComplete()



  decode: =>
    @traverse(@packet, @decodeEach)
    @checkComplete()



  encodeEach: (value, key, parent) =>
    if value instanceof Date
      parent[key] = @encodeDate(value)

    else if @isFile(value)
      @files.push(true)
      @encodeFile value, (fileString) =>
        parent[key] = fileString
        @files.pop()
        @checkComplete()



  decodeEach: (value, key, parent) =>
    dateRegExp = /^\/Date\(\d+\)\/$/
    fileRegExp = /^\/File\(.+\)\/$/

    if dateRegExp.test(value)
      parent[key] = @decodeDate(value)

    else if fileRegExp.test(value)
      @files.push(true)
      @decodeFile value, (decodeFile) =>
        parent[key] = decodeFile
        @files.pop()
        @checkComplete()



  encodeDate: (date) =>
    timeStamp = date.getTime()
    return "/Date(#{timeStamp})/"



  decodeDate: (dateString) =>
    timeStamp = dateString.slice(6, dateString.length-2)
    timeStamp = parseInt(timeStamp)
    return new Date(timeStamp)



  ### @Public ###
  # (深度优先)遍历一颗树的全部叶子节点
  # callback(叶子key, 叶子value, 父节点parent)
  ##
  traverse: (tree, callback) =>
    @traverseEach(tree, null, null, callback)



  traverseEach: (node, key, parent, callback) =>
    # 嵌套对象
    if isPlainObject(node)
      for key, child of node
        @traverseEach(child, key, node, callback)
    # 数组
    else if Array.isArray(node)
      for child, i in node
        @traverseEach(child, i, node, callback)
    # 叶子节点
    else
      callback(node, key, parent)
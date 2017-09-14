_ = require('lodash')



module.exports = class Collection

  constructor: (options={}) ->
    @db      = options.db
    @idStore = options.idStore
    @name    = options.name
    @col     = @db.collection(@name)



  ### @PUBLIC ###
  # 单文档查询
  ##
  findOne: (query, options) =>
    query   = @formatQuery(query, options)
    options = @formatOptions(options)
    doc = await @col.findOne(query, options)
    return doc



  ### @PUBLIC ###
  # 多文档查询
  ##
  find: (query, options) =>
    query   = @formatQuery(query, options)
    options = @formatOptions(options)
    docs = await @col.find(query, options).toArray()
    return docs



  ### @PUBLIC ###
  # 统计文档数量
  ##
  count: (query, options) =>
    query   = @formatQuery(query, options)
    options = @formatOptions(options)
    return await @col.count(query, options)



  formatQuery: (query={}, options={}) =>
    # query=1 >> query={id: 1}
    if _.isFinite(query)
      query = {id: query}

    # query也许会被开发者复用
    # 为了避免副作用，每次都应该生成新副本
    query = Object.assign({}, query)

    # 如果没有设置joinRemoved，则忽略软删除的文档
    if !options.joinRemoved
      query.removeDate = {$exists: false}

    # 如果设置了onlyRemoved，则只处理软删除的文档
    if options.onlyRemoved
      query.removeDate = {$exists: true}

    return query



  formatOptions: (options={}) =>
    # options也许会被开发者复用
    # 为了避免副作用，每次都应该生成新副本
    options = Object.assign({}, options)
    @formatOptions_Sort(options)
    @formatOptions_Page(options)
    @formatOptions_Keys(options)
    return options



  formatOptions_Sort: (options) =>
    if _.isNumber(options.sort)
      options.sort = {_id: options.sort}



  formatOptions_Page: (options) =>
    page = options.page ? 1
    size = options.size ? 0
    skip = options.skip ? 0

    options.skip  = skip + ( page - 1 ) * size
    options.limit = size

    delete options.page
    delete options.size



  formatOptions_Keys: (options) =>
    if _.isString(options.keys)
      keys = options.keys.split(/\s+/) # '-name -age'      => ['-name', '-age']
      dict  = {}                       # ['-name', '-age'] => {name: 0, age: 0}
      for key in keys
        if key[0] is '-'
          dict[key.slice(1)] = 0
        else
          dict[key] = 1
      options.fields = dict



  ### @PUBLIC ###
  # 单文档插入
  ##
  insert: (doc) =>
    if(@idStore)
      doc.id = await @makeIDs()
    doc.createDate = new Date()

    result = await @col.insertOne(doc)
    doc    = result.ops[0]
    return doc



  ### @PUBLIC ###
  # 多文档插入
  ##
  insertMany: (docs) =>
    if(@idStore)
      start = await @makeIDs(docs.length)

    for doc in docs
      if(start)
        doc.id = start
        start++
      doc.createDate = new Date()

    result = await @col.insertMany(docs)
    docs   = result.ops
    return docs



  makeIDs: (count=1) =>
    query    = {_id: @name}
    modifier = {$inc: {'lastID': count}}
    opt      = {upsert: true, returnOriginal: false}

    result = await @db
      .collection(@idStore)
      .findOneAndUpdate(query, modifier, opt)

    last  = result.value.lastID
    start = last - (count - 1)
    return start



  ### @PUBLIC ###
  # 单文档更新
  ##
  update: (query, modifier, options) =>
    query    = @formatQuery(query, options)
    modifier = @formatModifier(modifier)
    result   = await @col.updateOne(query, modifier)
    return result.modifiedCount



  ### @PUBLIC ###
  # 多文档更新
  ##
  updateMany: (query, modifier, options) =>
    query    = @formatQuery(query, options)
    modifier = @formatModifier(modifier)
    result   = await @col.updateMany(query, modifier)
    return result.modifiedCount



  formatModifier: (modifier={}) =>
    # modifier也许会被开发者复用
    # 为了避免副作用，每次都应该生成新副本
    modifier = Object.assign({}, modifier, {
      $set:
        updateDate: new Date()
    })

    for key, value of modifier
      if key[0] is '$'
        # 修改器字段，即$inc, $push... 等
        $ = value
        if @idStore     then delete $.id           # 仅在设置了idStore时，禁止修改id
        if _.isEmpty($) then delete modifier[key]  # 删除空修改器，否则mongodb会抛异常，
      else
        # 普通字段，一律包裹进$set，然后从modifier根层清除
        modifier.$set[key] = value
        delete modifier[key]

    return modifier



  ### @PUBLIC ###
  # 单文档软删除
  ##
  remove: (query) ->
    count = await @update(query, {
      removeDate: new Date()
    })
    return count



  ### @PUBLIC ###
  # 多文档软删除
  ##
  removeMany: (query) ->
    count = await @updateMany(query, {
      removeDate: new Date()
    })
    return count



  ### @PUBLIC ###
  # 单文档硬删除
  ##
  delete: (query, options) ->
    query  = @formatQuery(query, options)
    result = await @col.deleteOne(query)
    return result.deletedCount



  ### @PUBLIC ###
  # 多文档硬删除
  ##
  deleteMany: (query, options) ->
    query  = @formatQuery(query, options)
    result = await @col.deleteMany(query)
    return result.deletedCount



  ### @PUBLIC ###
  # 单文档软恢复
  ##
  restore: (query) ->
    count = await @update(query, {
      $unset: removeDate: 1
    },{
      onlyRemoved: true
    })
    return count



  ### @PUBLIC ###
  # 多文档软恢复
  ##
  restoreMany: (query) ->
    count = await @updateMany(query, {
      $unset: removeDate: 1
    },{
      onlyRemoved: true
    })
    return count



  ### @PUBLIC ###
  # 聚合操作
  ##
  aggregate: (pipeline, options) ->
    results = await @col.aggregate(pipeline, options).toArray()
    return results
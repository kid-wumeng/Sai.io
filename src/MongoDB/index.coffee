_          = require('lodash')
mongodb    = require('mongodb')
helper     = require('../helper')
Collection = require('./Collection')
JoinQuery  = require('./JoinQuery')
error      = require('./error')



module.exports = class MongoDB

  constructor: (options={}) ->
    @host    = options.host ? '0.0.0.0'
    @port    = options.port ? 27017
    @name    = options.name ? 'test'
    @user    = options.user
    @pass    = options.pass
    @idStore = options.idStore
    @aliases = {}
    @hides   = {}
    @db      = null
    @cols    = {}



  ### @Public ###
  # 连接数据库
  ##
  connect: =>
    uri = @formatUri()
    @db = await mongodb.MongoClient.connect(uri)
    await @ensureIDStore()



  ### @Public ###
  # 删除数据库
  ##
  drop: =>
    await @db.dropDatabase()



  formatUri: =>
    # uri格式参考：
    # https://docs.mongodb.com/manual/reference/connection-string/
    if @user
      return "mongodb://#{@user}:#{@pass}@#{@host}:#{@port}/#{@name}"
    else
      return "mongodb://#{@host}:#{@port}/#{@name}"



  ### @Public ###
  # 关闭数据库链接
  ##
  close: =>
    await @db.close()



  ensureIDStore: =>
    if(@idStore)
      stores = await @col(@idStore).find()
      for store in stores
        await @ensureIDStoreEach(store)



  ensureIDStoreEach: (store) =>
    col = store._id
    doc = await @col(col).findOne({
      id: $exists: true
    },{
      sort: -1
      keys: 'id'
      includeRemoved: true
    })
    if(doc and store.lastID < doc.id)
      error.IDStore_Overflow({
        col: col
        lastID: doc.id
        idStore: @idStore
        lastIDInStore: store.lastID
      })



  ### @Public ###
  # 设置集合的别名
  ##
  alias: (origin, alias) =>
    @aliases[alias] = origin



  ### @Public ###
  # 隐藏某个集合的某个字段，使其只能配合includeHide才查询得到
  ##
  hide: (col, key) =>
    col = @aliases[col] ? col
    if !@hides[col]
      @hides[col] = []
    @hides[col].push(key)



  ### @Public ###
  # 选择集合
  ##
  col: (name) =>
    name = @aliases[name] ? name

    if !@cols[name]
      @cols[name] = new Collection({
        db:      @db
        idStore: @idStore
        hides:   @hides
        name:    name
      })

    return @cols[name]


  ### @Public ###
  # 创建 DBRef 对象
  ##
  DBRef: (col, doc={}) =>
    if not @validObjectID(doc?._id)
      error.DBRef_ID_Invalid({doc})

    return{
      $ref: col
      $id:  doc._id
      $db:  @name
    }



  ### @Public ###
  # 验证_id是否有效
  ##
  validObjectID: (_id) =>
    return mongodb.ObjectID.isValid(_id)



  ### @Public ###
  # 验证_id是否有效
  ##
  join: (docs, key, options) =>
    joinQuery = new JoinQuery({
      mongo: @
      docs: docs
      key: key
      options: options
    })
    await joinQuery.execule()
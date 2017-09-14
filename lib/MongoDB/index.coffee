mongodb    = require('mongodb')
Collection = require('./Collection')
helper     = require('../helper')



module.exports = class MongoDB

  constructor: (options={}) ->
    @host    = options.host ? '0.0.0.0'
    @port    = options.port ? 27017
    @name    = options.name ? 'test'
    @user    = options.user
    @pass    = options.pass
    @idStore = options.idStore
    @aliases = {}
    @db      = null



  ### @PUBLIC ###
  # 设置集合的别名
  ##
  alias: (origin, alias) =>
    @aliases[alias] = origin



  ### @PUBLIC ###
  # 打开数据库
  ##
  connect: =>
    uri = @formatUri()
    @db = await mongodb.MongoClient.connect(uri)
    await @ensureIDStore()



  formatUri: =>
    # uri格式参考：
    # https://docs.mongodb.com/manual/reference/connection-string/
    if @user
      return "mongodb://#{@user}:#{@pass}@#{@host}:#{@port}/#{@name}"
    else
      return "mongodb://#{@host}:#{@port}/#{@name}"



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
      idOverflow({
        col: col
        lastID: doc.id
        idStore: @idStore
        lastIDInStore: store.lastID
      })




  ### @PUBLIC ###
  # 关闭数据库链接
  ##
  close: =>
    await @db.close()



  ### @PUBLIC ###
  # 选择集合
  ##
  col: (name) =>
    name = @aliases[name] ? name
    return new Collection({
      db: @db
      idStore: @idStore
      name: name
    })



###
# 异常处理方法
###
idOverflow = ({col, lastID, idStore, lastIDInStore}) =>
  helper.throw({
    code: 12002
    zh_message: "集合`#{col}`的id超出了idStore的记录，#{col}: #{lastID}，#{idStore}.#{col}: #{lastIDInStore}，请核验后校准"
    info: {col, lastID, lastIDInStore}
  })
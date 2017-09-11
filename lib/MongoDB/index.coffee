mongodb    = require('mongodb')
Collection = require('./Collection')



module.exports = class MongoDB

  constructor: (options={}) ->
    @host = options.host ? '0.0.0.0'
    @port = options.port ? 27017
    @name = options.name ? 'test'
    @user = options.user
    @pass = options.pass
    @db   = null



  ### @PUBLIC ###
  # url格式参考：https://docs.mongodb.com/manual/reference/connection-string/
  ##
  connect: =>
    if(@user)
      auth = "#{@user}:#{@pass}@"
    else
      auth = ''
    @db = await mongodb.MongoClient.connect("mongodb://#{auth}#{@host}:#{@port}/#{@name}")



  ### @PUBLIC ###
  # 选择集合
  ##
  col: (name) ->
    return new Collection({
      db: @db
      name: name
    })
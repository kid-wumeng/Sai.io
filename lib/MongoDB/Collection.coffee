_ = require('lodash')



module.exports = class Collection

  constructor: (options={}) ->
    @db   = options.db
    @name = options.name
    @col  = @db.collection(@name)



  ### @PUBLIC ###
  # 单文档查询
  ##
  findOne: (query, options) =>
    query   = @formatQuery(query)
    options = @formatQueryOptions(options)
    doc = await @col.findOne(query, options)
    return doc



  ### @PUBLIC ###
  # 多文档查询
  ##
  find: (query, options) =>
    query   = @formatQuery(query)
    options = @formatQueryOptions(options)
    docs = await @col.find(query, options).toArray()
    return docs



  formatQuery: (query={}) =>
    if _.isFinite(query)
      query = {id: query}  # 1 => {id: 1}

    # query可能被开发者复用，所以每次都要生成新副本，以避免出现副作用
    return Object.assign({}, query, {
      removeDate:
        $exists: false
    })



  formatQueryOptions: (options={}) =>
    # options可能被开发者复用，所以每次都要生成新副本，以避免出现副作用
    options = Object.assign({}, options)
    @formatQueryPage(options)
    @formatQueryFields(options)
    return options



  formatQueryFields: (options) =>
    if _.isString(options.fields)
      array = options.fields.split(/\s+/)  # '-name -age' => ['-name', '-age']
      dict  = {}                           # ['-name', '-age'] => {name: 0, age: 0}
      for key in array
        if key[0] is '-'
          dict[key.slice(1)] = 0
        else
          dict[key] = 1
      options.fields = dict



  formatQueryPage: (options) =>
    page = options.page ? 1
    size = options.size ? 0
    skip = options.skip ? 0

    options.skip  = skip + ( page - 1 ) * size
    options.limit = size

    delete options.page
    delete options.size
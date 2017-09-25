_ = require('lodash')


### JoinQuery ###
# 负责基于DBRef模式的联合查询
# 本类中的所有id皆指代_id，而不是idStore生成的id
##


module.exports = class JoinQuery

  constructor: (options={}) ->
    @mongo   = options.mongo
    @docs    = options.docs ? []  # 请求联合的文档集
    @key     = options.key  ? ''  # DBRef在文档中的key
    @options = options.options    # 这个是用于find(query, options)的options



  execule: () =>
    # 单文档 >> 多文档，之后的流程都以多文档为基准
    docs = if Array.isArray(@docs) then @docs else [@docs]

    joinCol = @sureCol(docs)
    return if !joinCol

    joinIDs  = @collectIDs(docs, joinCol)
    joinDocs = await @findJoinDocs(joinCol, joinIDs)
    joinDict = @toJoinDict(joinDocs)

    @setToDocs(docs, joinDict)



  # 确定唯一的col，以第一个有效文档的DBRef为基准
  sureCol: (docs) =>
    for doc in docs
      dbRefs = _.get(doc, @key)
      col = @sureColEach(dbRefs)
      return col if col
    return null



  # 确定唯一的col，以第一个有效文档的DBRef为基准
  sureColEach: (dbRefs) =>
    dbRefs = [dbRefs] if !Array.isArray(dbRefs)
    for dbRef in dbRefs
      if dbRef.namespace
        return dbRef.namespace
    return null



  # 收集_id
  collectIDs: (docs, joinCol) =>
    ids = []
    for doc in docs
      dbRefs  = _.get(doc, @key)
      eachIDs = @collectIDsEach(dbRefs, joinCol)
      ids     = ids.concat(eachIDs)
    return ids



  collectIDsEach: (dbRefs, joinCol) =>
    dbRefs = [dbRefs] if !Array.isArray(dbRefs)
    return dbRefs
      .filter((dbRef) => dbRef.namespace is joinCol)
      .filter((dbRef) => dbRef.oid)
      .map((dbRef) => dbRef.oid)



  findJoinDocs: (joinCol, joinIDs) =>
    return await @mongo.col(joinCol).find({
      _id:
        $in: joinIDs
    }, @options)



  toJoinDict: (joinDocs) =>
    dict = {}
    for joinDoc in joinDocs
      dict[joinDoc._id] = joinDoc
    return dict



  setToDocs: (docs, joinDict) =>
    for doc in docs
      @setToDoc(doc, joinDict)



  setToDoc: (doc, joinDict) =>
    dbRefs = _.get(doc, @key)
    if Array.isArray(dbRefs)
      @replaceDBRefs(doc, joinDict, dbRefs)
    else
      dbRef = dbRefs
      @replaceDBRef(doc, joinDict, dbRef)



  # key: [DBRef_1, DBRef_2] >> key: [joinDoc_1, joinDoc_2]
  replaceDBRefs: (doc, joinDict, dbRefs) =>
    for dbRef, i in dbRefs
      joinDoc = joinDict[dbRef.oid]
      _.get(doc, @key)[i] = joinDoc



  # key: DBRef >> key: joinDoc
  replaceDBRef: (doc, joinDict, dbRef) =>
    joinDoc = joinDict[dbRef.oid]
    _.set(doc, @key, joinDoc)
helper = require('../helper')


exports.IDStore_Overflow = ({col, lastID, idStore, lastIDInStore}) =>
  helper.throw({
    code: 1101
    zh_message: "集合`#{col}`的id超出了idStore的记录，#{col}: #{lastID}，#{idStore}.#{col}: #{lastIDInStore}，请核验后校准"
    info: {col, lastID, idStore, lastIDInStore}
  })


exports.DBRef_ID_Invalid = ({doc}) =>
  helper.throw({
    code: 1102
    zh_message: "DBRef 生成失败，执行 mongo.DBRef(colname, doc) 时发现 doc._id 不是有效的 MongoDB ObjectID"
    info: {doc}
  })
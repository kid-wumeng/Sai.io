config = require('./config')



# 全局未捕获异常，需触发config.onCatch
#
# 以下异常已被妥善处理
# 1. 经由http请求触发的异常，这类异常由app.catch()加工后自行触发config.onCatch
# 2. 开发者以try...catch捕获的异常，由其自行处理，一般不会触发onCatch（除非开发者主动调用）
#
# 除此之外的异常，将会进入uncaughtException流程
# NodeJS策略：触发uncaughtException后，程序会被强制退出
process.on 'uncaughtException', (error) => config.onCatch(error)



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



# 错误码表
# 归拢在一起方便管理
code =
  # App
  IO_Not_Found:      1001
  Service_Not_Found: 1002
  # MongoDB
  IDStore_Overflow:  1101
  DBRef_ID_Invalid:  1102



exports.IO_Not_Found = ({ ioName }) =>
  @throw({
    status: 404
    code: code.IO_Not_Found
    zh_message: "IO #{ioName} 未找到，是不是没用 app.io() 注册？"
    data:
      ioName
  })



exports.Service_Not_Found = ({ serviceName }) =>
  @throw({
    status: 404
    code: code.Service_Not_Found
    zh_message: "服务 #{serviceName} 未找到，是不是没用 app.service() 注册？"
    data:
      serviceName
  })


exports.IDStore_Overflow = ({col, lastID, idStore, lastIDInStore}) =>
  @throw({
    code: code.IDStore_Overflow
    zh_message: "集合`#{col}`的id超出了idStore的记录，#{col}: #{lastID}，#{idStore}.#{col}: #{lastIDInStore}，请核验后校准"
    info: {col, lastID, idStore, lastIDInStore}
  })


exports.DBRef_ID_Invalid = ({doc}) =>
  @.throw({
    code: code.DBRef_ID_Invalid
    zh_message: "DBRef 生成失败，执行 mongo.DBRef(colname, doc) 时发现 doc._id 不是有效的 MongoDB ObjectID"
    info: {doc}
  })
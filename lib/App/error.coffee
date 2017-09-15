helper = require('../helper')


exports.IO_Not_Found = ({ ioName }) =>
  helper.throw({
    status: 404
    code: 1001
    zh_message: "IO #{ioName} 未找到，是不是没用 app.io() 注册？"
    data: {ioName}
  })


exports.Service_Not_Found = ({ serviceName }) =>
  helper.throw({
    status: 404
    code: 1002
    zh_message: "服务 #{serviceName} 未找到，是不是没用 app.service() 注册？"
    data: {serviceName}
  })
helper = require('../../helper')


module.exports = (name) =>
  helper.throw({
    status: 404
    code: 1002
    zh_message: "方法 #{name} 未找到，是不是没用 app.method() 注册？"
    data: {name}
  })
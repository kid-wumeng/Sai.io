helper = require('../../helper')


module.exports = (name) =>
  helper.throw({
    status: 404
    code: 1001
    zh_message: "IO #{name} 未找到，是不是没用 app.io() 注册？"
    data: {name}
  })
EventBus = require('./EventBus')


globalEventBus = new EventBus()


### @Public ###
# 全局错误事件，方便开发调试与日志记录
# 主线程的未捕获异常
# 注意，uncaughtException触发后会导致程序强退（NodeJS策略，合理）
process.on 'uncaughtException',  (error) => globalEventBus.emit('error', error)
# Promise引起的未捕获异常
process.on 'unhandledRejection', (error) => globalEventBus.emit('error', error)
##


module.exports = globalEventBus
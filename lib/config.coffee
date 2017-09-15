###
# Sai全局配置
# 开发者可直接对Sai.config.xxx赋值
# 单例，即全局唯一、全局共享
###



### @PUBLIC ###
# 语言，影响系统层面的异常信息
# 不影响开发者自己设定的异常信息
# 'en' - 英文
# 'zh' - 简体中文
##
exports.language = 'en'



### @PUBLIC ###
# 全局异常捕获事件，可捕获到：
# 1. NodeJS运行期异常
# 2. Sai-error
# 3. 开发者自行抛出的error
# 主要目的：方便debug与日志记录
#
# app.catch()已妥善处理由http请求引发的异常
# 除此之外的异常，需要用下面2个事件捕获，并交给config.onCatch
#
# 主线程的未捕获异常
# 注意，uncaughtException触发后会导致程序强退（NodeJS策略，合理）
process.on 'uncaughtException',  (error) => @onCatch(error)
# Promise引起的未捕获异常
process.on 'unhandledRejection', (error) => @onCatch(error)
##
exports.onCatch = (error) =>
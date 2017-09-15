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
# error的属性：
# - status
# - code
# - message
# - data
# @TODO 记录网络调用附加信息
##
exports.onCatch = (error) =>

# 全局未捕获异常，需触发config.onCatch
#
# 以下异常已被妥善处理
# 1. 经由http请求触发的异常，这类异常由app.catch()加工后自行触发config.onCatch
# 2. 开发者以try...catch捕获的异常，由其自行处理，一般不会触发onCatch（除非开发者主动调用）
#
# 除此之外的异常，将会进入uncaughtException流程
# NodeJS策略：触发uncaughtException后，程序会被强制退出
process.on 'uncaughtException', (error) => @onCatch(error)
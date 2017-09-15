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

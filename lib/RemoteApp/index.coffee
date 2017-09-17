_         = require('lodash')
Task      = require('./Task')
TaskGroup = require('./TaskGroup')



module.exports = class RemoteApp

  constructor: (options={}) ->
    if _.isString(options)
      options = host: options

    @host = options.host ? 'http://0.0.0.0:80'



  ### @Public ###
  # 配置
  ##
  config: (key, value) =>
    @[key] = value



  ### @Public ###
  # 调用远程method
  ##
  call: (a1, params...) =>
    if _.isString(a1)
      method = a1
      task = @task(method, params...)
      setTimeout(task.send, 0)
      return task
    else
      tasks = a1
      taskGroup = @taskGroup(tasks)
      setTimeout(taskGroup.send, 0)
      return taskGroup



  ### @Public ###
  # 顺序调用远程method
  ##
  callSeq: (tasks) =>
    taskGroup = @taskGroup(tasks)
    setTimeout(taskGroup.sendSeq, 0)
    return taskGroup



  ### @Public ###
  # 并行调用远程method
  ##
  callParal: (tasks) =>
    taskGroup = @taskGroup(tasks)
    setTimeout(taskGroup.sendParal, 0)
    return taskGroup



  ### @Public ###
  # 包装任务
  ##
  task: (method, params...) =>
    return new Task({
      host: @host
      method
      params
    })



  taskGroup: (tasks) =>
    return new TaskGroup({
      host: @host
      tasks
    })
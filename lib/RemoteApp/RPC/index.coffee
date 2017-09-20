Task      = require('./Task')
TaskGroup = require('./TaskGroup')



module.exports = class RPC

  constructor: (client) ->
    @client = client



  call: (method, params) =>
    task = new Task(method, params)
    @send(task)
    return task



  callBatch: (tasks) =>
    taskGroup = new TaskGroup(tasks)
    @send(taskGroup)
    return taskGroup



  callSeq: (tasks) =>
    taskGroup = new TaskGroup(tasks)
    last      = tasks.length - 1

    for task, i in tasks
      if i < last
        next = tasks[i+1]
        do (next) => task.always => @send(next)
      else
        task.always => taskGroup.complete()

    @send(tasks[0])
    return taskGroup



  callParal: (tasks) =>
    taskGroup = new TaskGroup(tasks)
    total     = tasks.length
    count     = 0

    for task in tasks
      task.always =>
        count += 1
        taskGroup.complete() if count is total
      @send(task)

    return taskGroup



  task: (method, params) =>
    return new Task(method, params)



  send: (taskOrTaskGroup) =>
    setTimeout =>
      @client.send(taskOrTaskGroup.getPacket(), taskOrTaskGroup.complete)
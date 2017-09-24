module.exports = class TaskGroup

  constructor: (tasks) ->
    @tasks = tasks
    @dones = []
    @fails = []



  doneEach: (callback) =>
    for task in @tasks
      task.done(callback)
    return @



  failEach: (callback) =>
    for task in @tasks
      task.fail(callback)
    return @



  done: (callback) =>
    @dones.push(callback)
    return @



  fail: (callback) =>
    @fails.push(callback)
    return @



  getPacket: =>
    tasks = @tasks.map (task) => task.getTask()
    return
      type: 'json-rpc'
      batch: true
      tasks: tasks



  receive: (response) =>
    packages = response.data
    helper.decodeBody(packages)

    # @TODO 支持通知后需要比对id来对应触发
    for task, i in @tasks
      task.complete(packages[i])

    @complete()



  complete: (packet) =>
    # @TODO 支持通知后需要比对id来对应触发
    for task, i in @tasks
      task.complete(packet[i])

    done() for done in @dones



  timeout: =>
    for task, i in @tasks
      task.timeout()

    fail() for fail in @fails
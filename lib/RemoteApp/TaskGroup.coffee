axios  = require('axios')
helper = require('../helper')



module.exports = class TaskGroup

  constructor: (options={}) ->
    @host  = options.host
    @tasks = options.tasks
    @dones = []



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



  send: () =>
    packages = @tasks.map (task) =>
      jsonrpc: '2.0'
      id:     task.id
      method: task.method
      params: task.params

    helper.encodeBody(packages)

    axios
      .post(@host, packages)
      .then(@receive)



  sendSeq: () =>
    total = @tasks.length

    for task, i in @tasks
      if i < total - 1
        next = @tasks[i+1]
        do (next) => task.always => next.send()
      else
        task.always => @complete()
        
    @tasks[0].send()



  sendParal: () =>
    total = @tasks.length
    count = 0
    for task in @tasks
      task.always =>
        count += 1
        @complete() if count is total
      task.send()



  receive: (response) =>
    packages = response.data
    helper.decodeBody(packages)

    # @TODO 支持通知后需要比对id来对应触发
    for task, i in @tasks
      task.complete(packages[i])

    @complete()



  complete: =>
    done() for done in @dones
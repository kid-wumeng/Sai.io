Subscription = require('./Subscription')



### Store ###
##



module.exports = class Store

  constructor: (options={}) ->
    @subs  = {}
    @dones = []
    @fails = []



  subscribe: (topic, callback) =>
    @subs[topic] = new Subscription(topic, callback)



  done: (callback) =>
    @dones.push(callback)



  fail: (callback) =>
    @fails.push(callback)



  emit: (event, data) =>
    switch event
      when 'done' then done(data) for done in @dones
      when 'fail' then fail(data) for fail in @fails
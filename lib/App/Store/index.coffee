helper = require('../../helper')
errors = require('../../errors')
IO     = require('./IO')
Method = require('./Method')
Topic  = require('./Topic')



### Store ###
##



module.exports = class Store

  constructor: (options={}) ->
    @ios     = {}
    @methods = {}
    @topics  = {}
    @mounts  = {}



  ### @Public ###
  # 注册io
  ##
  io: (name, func) =>
    @ios[name] = new IO({name, func})



  ### @Public ###
  # 注册method
  ##
  method: (args...) =>
    a1 = args[0]
    a2 = args[1]
    a3 = args[2]

    { overload } = helper
    switch
      when overload(args, String)                 then method_name = a1; io_name = a1; options = {}
      when overload(args, String, String)         then method_name = a1; io_name = a2; options = {}
      when overload(args, String, Object)         then method_name = a1; io_name = a1; options = a2
      when overload(args, String, String, Object) then method_name = a1; io_name = a2; options = a3

    io = @ios[io_name]
    if io
      @methods[method_name] = new Method(method_name, io, options)
    else
      throw errors.IO_NOT_FOUND(io_name)



  ### @Public ###
  # 注册主题
  ##
  topic: (name, filter) =>
    @topics[name] = new Topic({name, filter})



  ### @Public ###
  # 挂载属性到ctx上
  ##
  mount: (key, value) =>
    @mounts[key] = value
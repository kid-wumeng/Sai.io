uuidv4  = require('uuid/v4')
SaiJSON = require('../../../assets/SaiJSON')



module.exports = class PostOffice


  constructor: (adapter, options, socket, eventBus) ->
    @saiJSON  = new SaiJSON(adapter)
    @socket   = socket
    @eventBus = eventBus
    @timeout  = options.timeout
    @dict     = {}

    @eventBus.on('message', @receive)



  send: (packet, complete, timeout) =>
    # 编码数据
    @saiJSON.encode packet, =>
      # 封包、盖戳
      {stamp, message} = @seal(packet)
      # 记录"完成"与"超时"事件，邮戳是找寻依据
      @dict[stamp] = {complete, timeout}
      # 寄出
      @socket.send(message)
      # 设置计时器，到点触发，用以判断是否超时
      setTimeout (=> @handleTimeout(stamp)), @timeout



  seal: (packet, callback) =>
    stamp   = uuidv4()
    message = {stamp, packet}
    message = JSON.stringify(message)
    return {stamp, message}



  receive: (message) =>
    # 启封
    {stamp, packet} = @unseal(message)
    # 若邮戳不存在，说明是一个"主题发布"
    # 这种情况邮局不处理，会由realtime监听message事件来处理
    if(stamp)
      # 根据邮戳找到记录（确认没有因为超时而消除）
      if @dict[stamp]
        # 取出"完成"事件
        {complete} = @dict[stamp]
        # 消除记录
        delete @dict[stamp]
        # 解码数据
        @saiJSON.decode packet, =>
          # 激活"完成"事件
          complete(packet)



  unseal: (message) =>
    message = JSON.parse(message)
    return message



  handleTimeout: (stamp) =>
    # 记录存在说明没有被完成，判定为超时
    if @dict[stamp]
      # 取出"超时"事件
      {timeout} = @dict[stamp]
      # 消除记录
      delete @dict[stamp]
      # 激活"超时"事件
      timeout()
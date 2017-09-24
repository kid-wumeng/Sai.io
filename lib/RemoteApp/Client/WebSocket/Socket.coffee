WebSocket = require('ws')



module.exports = class Socket


  constructor: (url, adapter, options, eventCenter) ->
    @url         = url
    @adapter     = adapter
    @eventCenter = eventCenter

    @reconnectInterval    = options.reconnectInterval
    @reconnectIntervalMax = options.reconnectIntervalMax
    @reconnectDecay       = options.reconnectDecay
    @reconnectCount       = 0
    @reconnectTimer       = null

    @ws     = null
    @isOpen = false

    @first         = true
    @firstMessages = []
    @readyMessages = []

    @connect()



  connect: =>
    @isOpen = false
    @ws = new WebSocket(@url)
    @addEventListener('open',    @handleOpen)
    @addEventListener('close',   @handleClose)
    @addEventListener('error',   @handleError)
    @addEventListener('message', @handleMessage)



  reconnect: =>
    @connect()
    delay = @computeReconnectDelay()
    @reconnectTimer = setTimeout(@reconnect, delay)


  ### @private ###
  # 计算某次重连的延时
  ##
  computeReconnectDelay: =>
    interval    = @reconnectInterval
    intervalMax = @reconnectIntervalMax
    decay       = @reconnectDecay
    count       = @reconnectCount++

    delay = interval * Math.pow(decay, count)

    if delay > intervalMax
       delay = intervalMax

    return delay




  handleOpen: =>
    clearTimeout(@reconnectTimer)
    @reconnectTimer = null
    @reconnectCount = 0
    @isOpen = true

    if(@first)
      @first = false
      @sendFirst()
    @eventCenter.emit('open')



  handleClose: =>
    @isOpen = false
    if(!@reconnectTimer)
      @reconnect()
    @eventCenter.emit('close')



  handleError: =>
    @isOpen = false
    @eventCenter.emit('error')



  handleMessage: (message) =>
    @eventCenter.emit('message', message.data)



  sendFirst: =>
    for message in @firstMessages
      @send(message)
    @firstMessages = []



  send: (message) =>
    if(@first)
      @firstMessages.push(message)
    else if @isOpen
      @ws.send(message)
    else
      @readyMessages.push(message)



  addEventListener: (event, callback) =>
    if @ws.addEventListener
       @ws.addEventListener(event, callback)
    else
       @ws.on(event, callback)
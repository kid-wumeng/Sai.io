WebSocket   = require('ws')
BAD_NETWORK = require('../../../errors/BAD_NETWORK')



module.exports = class Socket


  constructor: (url, adapter, options, eventBus) ->
    @url      = url
    @adapter  = adapter
    @eventBus = eventBus

    @reconnectInterval    = options.reconnectInterval
    @reconnectIntervalMax = options.reconnectIntervalMax
    @reconnectDecay       = options.reconnectDecay
    @reconnectCount       = 0
    @reconnectTimer       = null

    @ws     = null
    @isOpen = false

    @first         = true
    @firstMessages = []

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
    @eventBus.emit('open')



  handleClose: =>
    @isOpen = false
    if(!@reconnectTimer)
      @reconnect()
    @eventBus.emit('close')



  handleError: =>
    @isOpen = false
    @eventBus.emit('error')



  handleMessage: (message) =>
    @eventBus.emit('message', message.data)



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
      throw BAD_NETWORK()



  addEventListener: (event, callback) =>
    if @ws.addEventListener
       @ws.addEventListener(event, callback)
    else
       @ws.on(event, callback)
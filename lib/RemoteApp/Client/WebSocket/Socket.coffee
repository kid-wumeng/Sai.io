WebSocket = require('ws')



module.exports = class Socket


  constructor: (url) ->
    @url    = url
    @ws     = null
    @isOpen = false

    @first         = true
    @firstMessages = []

    @openCallbacks    = []
    @closeCallbacks   = []
    @errorCallbacks   = []
    @messageCallbacks = []

    @connect()



  connect: =>
    @isOpen = false
    @ws = new WebSocket(@url)
    @addEventListener('open',    @handleOpen)
    @addEventListener('close',   @handleClose)
    @addEventListener('error',   @handleError)
    @addEventListener('message', @handleMessage)



  handleOpen: =>
    @isOpen = true
    if(@first)
      @first = false
      @sendFirst()
    callback() for callback in @openCallbacks



  handleClose: =>
    @isOpen = false
    callback() for callback in @closeCallbacks



  handleError: =>
    @isOpen = false
    callback() for callback in @errorCallbacks



  handleMessage: (message) =>
    message = message.data
    callback(message) for callback in @messageCallbacks



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
      throw 'hgf'



  on: (event, callback) =>
    @[event+'Callbacks'].push(callback)



  addEventListener: (event, callback) =>
    if @ws.addEventListener
       @ws.addEventListener(event, callback)
    else
       @ws.on(event, callback)
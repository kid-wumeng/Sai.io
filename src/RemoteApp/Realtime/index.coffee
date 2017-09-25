module.exports = class RPC

  constructor: (client, store) ->
    @client = client
    @store  = store
    @listen()



  listen: =>
    @client.on 'message', (message) =>
      message = JSON.parse(message)
      {stamp} = message
      if !stamp
        {topic, params} = message
        sub = @store.subs[topic]
        if(sub)
          sub.call(params)
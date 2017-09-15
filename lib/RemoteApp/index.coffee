_      = require('lodash')
axios  = require('axios')
helper = require('../helper')



module.exports = class RemoteApp

  constructor: (options={}) ->
    if _.isString(options)
      options = host: options

    @host = options.host ? 'http://0.0.0.0:80'



  ### @PUBLIC ###
  # 配置
  ##
  config: (key, value) =>
    @[key] = value



  call: (service, params...) =>
    url = "#{@host}/#{service}"
    axios.post(url, {
      jsonrpc: '2.0'
      method: service
      params: params
    }).then((res)=>
      console.log(res.data.result);
    ).catch((error)=>
      console.log(error.response.status);
      console.log(error.response.data.error);
    )
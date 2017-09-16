_      = require('lodash')
axios  = require('axios')
helper = require('../helper')



module.exports = class RemoteApp

  constructor: (options={}) ->
    if _.isString(options)
      options = host: options

    @host = options.host ? 'http://0.0.0.0:80'



  ### @Public ###
  # 配置
  ##
  config: (key, value) =>
    @[key] = value



  ### @Public ###
  # 调用远程method
  ##
  call: (arg1, args...) =>
    if _.isString(arg1)
      body = @task(arg1, args...)  # call(method, params...)
    else
      body = arg1                  # call(tasks)

    return axios
      .post(@host, body)
      .then(@onSuccess)
      .catch(@onFailure)



  ### @Public ###
  # 调用远程method
  ##
  task: (method, params...) =>
    return{
      jsonrpc: '2.0'
      method: method
      params: params
    }



  onSuccess: (response) =>
    responseBody = response.data
    helper.decodeBody(responseBody)
    return responseBody.result



  onFailure: ({response}) =>
    responseBody = response.data
    helper.decodeBody(responseBody)
    return responseBody.error
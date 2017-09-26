assets = require('../../assets')
Rule   = require('./Rule')
Format = require('./Format')



### Store ###
##



module.exports = class Store

  constructor: (options={}) ->
    @rules   = {}
    @formats = {}

    @format('email', assets.isEmail)
    @format('url', assets.isUrl)



  ### @Public ###
  # 定制规则
  ##
  rule: (name, check) =>
    @rules[name] = new Rule(name, check)



  ### @Public ###
  # 定制格式
  ##
  format: (name, check) =>
    @formats[name] = new Format(name, check)
cons = require('consolidate')



module.exports = class Document

  constructor: (store) ->
    @store = store



  render: =>
    methods = @store.methods
    methods = Object.values(methods)
    methods.sort((method1, method2) -> method2.name < method1.name)
    methods = methods.map (method) ->
      method = Object.assign({}, method)
      method.paramsString = method.params.map (param) ->
        if(param.subs)
          subnames = param.subs.map (sub) -> sub.name
          return '{' + subnames.join(', ') + '}'
        else
          return param.name
      method.paramsString = method.paramsString.join(', ')
      return method

    gets = @store.gets
    gets = Object.values(gets)
    gets.sort((get1, get2) -> get2.path < get1.path)
    gets = gets.map (get) ->
      get = Object.assign({}, get)
      # get.paramsString = get.params.map (param) ->
      #   if(param.subs)
      #     subnames = param.subs.map (sub) -> sub.name
      #     return '{' + subnames.join(', ') + '}'
      #   else
      #     return param.name
      # get.paramsString = get.paramsString.join(', ')
      return get

    return cons.mustache(__dirname + '/template.html', {methods, gets})
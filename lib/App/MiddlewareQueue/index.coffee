module.exports = class Middleware


  constructor: (options) ->
    @mids = []



  use: (mid) =>
    @mids.push(mid)



  dispatch: (ctx) =>
    invoke = (i) =>
      if i < @mids.length - 1
        @mids[i].call(ctx, -> invoke(i+1))
      else
        @mids[i].call(ctx, ->)

    invoke(0)
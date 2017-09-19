module.exports = class Middleware

  constructor: (options) ->
    @mids = []


  use: (mid) =>
    @mids.push(mid)


  dispatch: (ctx) =>
    total = @mids.length

    invoke = (i) =>
      mid = @mids[i]
      if i < total - 1
        mid.call(ctx, -> invoke(i+1))
      else
        mid.call(ctx, ->)

    invoke(0)
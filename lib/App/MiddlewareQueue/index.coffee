module.exports = class Middleware


  constructor: (store) ->
    @store = store



  dispatch: (ctx) =>
    mids = @store.mids

    invoke = (i) =>
      func = mids[i].func
      if i < mids.length - 1
        await func.call(ctx, -> invoke(i+1))
      else
        await func.call(ctx, ->)

    await invoke(0)
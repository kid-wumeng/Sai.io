module.exports = class Middleware


  constructor: (store) ->
    @store = store



  insert: (mid) =>
    @store.mids.unshift(mid)



  append: (mid) =>
    @store.mids.push(mid)



  dispatch: (ctx) =>
    mids = @store.mids
    
    invoke = (i) =>
      func = mids[i].func
      if i < mids.length - 1
        await func.call(ctx, -> await invoke(i+1))
      else
        await func.call(ctx, ->)

    await invoke(0)
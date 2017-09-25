require('coffeescript/register')

;(async()=>{try{


  var Sai = require('./lib')
  var helper = require('./lib/helper')

  Sai.catch((error)=>{
    console.log(error.message.red);
    console.log(error.stack);
  })

  app = new Sai.App()

  app.io('abc', async function(id, name){
    return 'lll'
  })

  app.io('shop.findBook', async function(id, name){
    res = await this.call('abc')
    throw 'errrr'
    return {flag: new Date()}
  })

  app.method('getBooks', 'shop.findBook')
  app.get('books/:id/:name', 'shop.findBook')

  app.topic('timeline', function(a, b){
    return true
  })

  app.mount('token', 'uuuser')


  app.listen(9000)


  // setTimeout(function(){
  //   app.publish('timeline', 'kid', 18)
  // }, 1000)


  api = new Sai.RemoteApp('ws://127.0.0.1:9000')

  // api.subscribe('timeline', function(a, b){
  //   console.log('-=-=');
  //   console.log(a);
  //   console.log(typeof b);
  // })


  // api.call('getBooks', 8, new Date())
  //   .done(function(result){
  //     console.log(result);
  //   })
  //   .fail(function(error){
  //     console.log(error);
  //   })


  // api.fail((error)=>{
  //   console.log(error.message);
  // })


  api.get('books/6/3rd').done(result => console.log(result)).fail(error => console.log(error))

  // done = function(result){
  //   console.log(result.flag.toString());
  // }
  // fail = function(error){
  // }
  //
  // api.callBatch([
  //   api.task('shop.findBook', 'kid', new Buffer('wumeng')).done(done).fail(fail),
  //   api.task('shop.findBook2', 'kid', 6).done(done).fail(fail)
  // ]).done(()=>{
  // })




  // app.on('loading', function(n, a){
  //   console.log(n);
  //   console.log(a);
  // })



  // app.topic('addComment', function(data){
  //   return true
  // })
  //
  // setTimeout(()=>{
  //   app.publish('addComment', {name: 'kid'})
  // }, 5000)

  //
  // app.subscribe('addComment', (data)=>{
  //
  // })



  // code = new Sai.Code()
  // token = code.jwt.encode({
  //   name: 'kid',
  //   exp: 19999
  // }, 'hhhh')
  //
  // a = code.jwt.decode(token, 'hhhh')
  // console.log(a);
  //
  //
  // let api = new Sai.RemoteApp('http://127.0.0.1:9000/')

  // api.call('count', new Date()).done((result)=>{
  //   console.log(result);
  // }).fail((error)=>{
  //   console.log(error);
  // })

  // api.callSeq([
  //   api.task('count', 1),
  //   api.task('count', 2),
  //   api.task('count', 3),
  //   api.task('count', 4),
  //   api.task('count', 5),
  //   api.task('count', 6),
  //   api.task('count', 7),
  //   api.task('count', 8),
  //   api.task('count', 9),
  //   api.task('count', 10),
  // ]).doneEach((result)=>{
  //   console.log(result);
  // }).failEach((error)=>{
  //   console.log(error)
  // }).done(()=>{
  //   console.log('done');
  // })


  // console.log(tasks);


}catch(error){
  console.log(error);
}})()
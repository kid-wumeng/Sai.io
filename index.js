require('coffeescript/register')

;(async()=>{try{


  var Sai = require('./lib')
  var helper = require('./lib/helper')

  Sai.config.language = 'zh'
  Sai.config.onCatch = (error) => {
    console.log(error.message.red);
  }



  Middleware = require('./lib/App/Middleware')
  middleware = new Middleware()


  async function m1(next){
    console.log('m1 start');
    this.name = 'yyy'
    await next()
    console.log('m1 end');
  }

  async function m2(next){
    console.log('m2 start');
    await helper.sleep(3000)

    await next()
    console.log(this.name);
    await helper.sleep(3000)
    console.log('m2 end');
  }

  async function m3(next){
    console.log('m3 start');
    await next()
    console.log('m3 end');
  }


  middleware.use(m1)
  middleware.use(m2)
  middleware.use(m3)

  console.log('-------');
  middleware.dispatch({name: 'kid'})




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
require('coffeescript/register')

;(async()=>{try{


  var Sai = require('./lib')
  var helper = require('./lib/helper')

  Sai.config.language = 'zh'
  Sai.config.onCatch = (error) => {
    console.log(error.message.red);
  }





  let app = new Sai.App({
    port: 9000
  })

  app.io('add', function(a, b){
    return a + b
  })

  app.io('count', async function(a, b){
    r = Math.random()
    r = parseInt(r * 3000)
    await helper.sleep(1000)
    return a
  })

  app.method('count')
  app.start()


  let api = new Sai.RemoteApp('http://127.0.0.1:9000/')

  // api.call('count', new Date()).done((result)=>{
  //   console.log(result);
  // }).fail((error)=>{
  //   console.log(error);
  // })

  api.callSeq([
    api.task('count', 1),
    api.task('count', 2),
    api.task('count', 3),
    api.task('count', 4),
    api.task('count', 5),
    api.task('count', 6),
    api.task('count', 7),
    api.task('count', 8),
    api.task('count', 9),
    api.task('count', 10),
  ]).doneEach((result)=>{
    console.log(result);
  }).failEach((error)=>{
    console.log(error)
  }).done(()=>{
    console.log('done');
  })


  // console.log(tasks);




}catch(error){
  console.log(error);
}})()
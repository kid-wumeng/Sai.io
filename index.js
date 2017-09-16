require('coffeescript/register')


let Sai = require('./lib')

Sai.config.language = 'zh'
Sai.config.onCatch = (error) => {
  console.log(error.message.red);
}



;(async()=>{try{




  let app = new Sai.App({
    port: 9000
  })

  app.io('add', function(a, b){
    return a + b
  })

  app.io('count', function(a, b){
    return this.call('add', a + b, 8)
  })

  app.method('count')
  app.start()


  let api = new Sai.RemoteApp('http://127.0.0.1:9000/')


  // api.call([
  //   api.task('Book.findOne', 4, 9),
  //   api.task('Book.findOne', 17, 35)
  // ])

  result = await api.call('count', 4, 9)
  console.log(result);


}catch(error){
  console.log(error);
}})()




module.exports = Sai
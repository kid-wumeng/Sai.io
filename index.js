require('coffeescript/register')

  let axios = require('axios')
  let Sai   = require('./lib')

  Sai.config.language = 'zh'
  Sai.config.onCatch = (error) => {
    console.log(error.message.red);
  }



;(async()=>{try{




  let app = new Sai.App({
    port: 9000
  })

  app.io('Book.findOne', function(user, n){
    console.log(user);
    console.log(n);
    return {lastDate: new Date()}
  })
  app.service('Book.findOne', 'Book.findOne')
  app.start()


  let api = new Sai.RemoteApp('http://127.0.0.1:9000')
  await api.call('Book.findOne', 4, 9)


}catch(error){
  console.log(error);
}})()




module.exports = Sai
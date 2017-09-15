require('coffeescript/register')

  let axios = require('axios')
  let Sai   = require('./lib')

  Sai.config.language = 'zh'
  Sai.config.onCatch = (error) => {
    console.log(error.message.red);
  }



;(async()=>{try{

  let mongo = new Sai.MongoDB({
    name: 'orz-world'
  })


  mongo.alias('movies', 'MMM')

  mongo.hide('movies', 'name')

  await mongo.connect()

  movies = await mongo.col('MMM').find({}, {
    keys: 'name',
    includeHides: true
  })
  console.log(movies);

  mongo.close()

}catch(error){
  console.log(error);
}})()



// let app = new Sai.App({
//   port: 9000
// })


// async function sleep(timeout) {
//   return new Promise((resolve, reject) => {
//     setTimeout(function() {
//       resolve();
//     }, timeout);
//   });
// }
//
//
// app.io('Book.findOne', function(data){
//   throw "gfd"
//   this.call('Book.findOne')
//   return {lastDate: new Date()}
// })
//
// app.io('Book.findOne2', function(data){
//   return {lastDate: new Date()}
// })
//
//
//
// app.call('fjdj')
//
//
//
// app.service('Book.findOne', 'Book.findOne')
// app.mount('myname', 'kid')
//
//
//
// app.start()
//
//
// data = {
//   id: 99,
//   createDate: new Date(),
// }
//
// helper.encodeBody(data)

// axios.post('http://localhost:9000/Book.findOne', {
//   data: data
// }).then((res)=>{
// }).catch((error)=>{
//   // console.log(error.response.status);
//   // console.log(error.response.data.error);
// })


module.exports = Sai
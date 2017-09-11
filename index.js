require('coffeescript/register')
let axios = require('axios')

let Sai = require('./lib')
let helper = require('./lib/helper')


Sai.config.language = 'zh'




;(async function(){



  let mongo = new Sai.MongoDB({
    name: 'orz-world'
  })

  try{
    await mongo.connect()

    options = {
      size: 3,
      fields: 'name'
    }

    subject = await mongo.col('Subject').find(8, options)

    console.log(options);

    console.log(subject);


  }catch(error){
    console.log(error);
  }



})()



// let app = new Sai.App({
//   port: 9000
// })
//
//
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
//   this.call('Book.findOne2')
//   return {lastDate: new Date()}
// })
//
// app.io('Book.findOne2', function(data){
//   return {lastDate: new Date()}
// })
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
//
// axios.post('http://localhost:9000/Book.findOne', {
//   data: data
// }).then((res)=>{
// }).catch((error)=>{
//   console.log(error.response.status);
//   console.log(error.response.data.error);
// })


module.exports = Sai
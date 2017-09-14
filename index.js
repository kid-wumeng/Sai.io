require('coffeescript/register')
let axios = require('axios')

let Sai = require('./lib')
let helper = require('./lib/helper')


Sai.config.language = 'zh'




;(async ()=>{



  let mongo = new Sai.MongoDB({
    name: 'orz-world',
    idStore: 'counter'
  })

  try{
    await mongo.connect()
    mongo.alias('Subject', 'subjects')



    // a = await mongo.col('movies').insertMany([
    //   {name: 'k1'},
    //   {name: 'k2'},
    //   {name: 'k3'},
    //   {name: 'k4'},
    //   {name: 'k5'},
    //   {name: 'k6'},
    //   {name: 'k7'},
    //   {name: 'k8'},
    //   {name: 'k9'},
    //   {name: 'k10'},
    //   {name: 'k11'},
    // ])

    results = await mongo.col('Collection').aggregate([{
      $match:{
        'subject.id': 101,
        'status': {
          $in: ['doing', 'done']
        },
        'score': {$gt: 0}
      }
    },{
      $group:{
        '_id': '$subject.id',
        'score':{
          $avg : '$score'
        }
    }}])

    console.log(results);


    await mongo.close()


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
require('coffeescript/register')
let axios = require('axios')

let Sai = require('./lib')

let app = new Sai.App({
  port: 9000
})


async function sleep(timeout) {
  return new Promise((resolve, reject) => {
    setTimeout(function() {
      resolve();
    }, timeout);
  });
}


app.io('Book.findOne', async ({id, createDate})=>{
  console.log(createDate.getFullYear());
  return '书的id:' + id
})


app.service('Book.findOne', 'Book.findOne')
app.mount('myname', 'kid')


app.start()


axios.post('http://localhost:9000/Book.findOne', {
  data: {
    id: 99,
    createDate: app.encodeDate(new Date()),
  }
}).then((res)=>{
  console.log(res.data);
})


module.exports = Sai
require('coffeescript/register')

let Sai = require('./lib')

let app = new Sai.App({
  port: 9000
})

app.io('Book.findOne', (id)=>{
  console.log(id);
  console.log('over');
})


app.service('Book.findOne', 'Book.findOne')


module.exports = Sai
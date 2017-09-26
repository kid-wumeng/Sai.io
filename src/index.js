require('coffeescript/register')

try{
  module.exports = require('./index.coffee')
}catch(error){
  console.log(error);
}
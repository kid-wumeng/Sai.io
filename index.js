require('coffeescript/register')

;(async()=>{try{


  var Sai = require('./lib')
  var helper = require('./lib/helper')

  Sai.config.language = 'zh'
  Sai.config.onCatch = (error) => {
    console.log(error.message.red);
    console.log(error.stack);
  }

  app = new Sai.App()

  app.io('wiki.getSubjects', function(name, file){
    return {flag: require('fs').readFileSync('./yyy.jpg')}
  })
  app.io('user.login', function(name, file){
    return {flag: require('fs').readFileSync('./yyy.jpg')}
  })
  app.io('user.getFeeds', function(name, file){
    return {flag: require('fs').readFileSync('./yyy.jpg')}
  })
  app.io('bbs.addPost', function(name, file){
    return {flag: require('fs').readFileSync('./yyy.jpg')}
  })

  app.method('wiki.getSubjects', {
    desc: '获取作品列表',
    params: [{
      name: 'options',
      subs: [{
        name: 'q'
      },{
        name: 'page'
      },{
        name: 'size'
      }]
    }]
  })

  app.method('user.login', {
    desc: '登录',
    params: [{
      name: 'email'
    },{
      name: 'password'
    }]
  })

  app.method('user.getFeeds', {
    desc: '获取用户动态',
    params: [{
      name: 'id'
    }]
  })

  app.method('bbs.addPost', {
    desc: '发帖',
    params: [{
      name: 'forum.id'
    },{
      name: 'title'
    },{
      name: 'content'
    },{
      name: 'isPushToTimeline'
    }]
  })

  app.listen(9000)


  api = new Sai.RemoteApp('ws://127.0.0.1:9000')

  // done = function(result){
  //   console.log(result.flag.toString());
  // }
  // fail = function(error){
  // }
  //
  // api.callBatch([
  //   api.task('shop.findBook', 'kid', new Buffer('wumeng')).done(done).fail(fail),
  //   api.task('shop.findBook2', 'kid', 6).done(done).fail(fail)
  // ]).done(()=>{
  // })




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
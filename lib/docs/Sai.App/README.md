# Sai.App


**[app.config( name, value )](#config)**     - 配置选项

**[app.use( middleware )](#use)**            - 使用中间件

**[app.mount( name, value )](#use)**         - 挂载上下文属性

**[app.io( name, fn )](#io)**                - 注册IO

**[app.service( path, io, opt )](#service)** - 注册RPC服务

**[app.GET( path, io, opt )](#GET)**         - 注册GET服务

**[app.POST( path, io, opt )](#POST)**       - 注册POST服务

**[app.PUT( path, io, opt )](#PUT)**         - 注册PUT服务

**[app.PATCH( path, io, opt )](#PATCH)**     - 注册PATCH服务

**[app.DELETE( path, io, opt )](#DELETE)**   - 注册DELETE服务


##### ``app.config(name, value)`` {#config}
```js
app.config('port', 80)
```
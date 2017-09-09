# Sai.App


## App
| 方法原型 | 描述 |
| --- | --- |
| [config(name, value)](#config)     | 配置选项 |
| [use(middleware)](#use)            | 使用中间件 |
| [mount(name, value)](#mount)       | 挂载上下文属性 |
| [io(name, fn)](#io)                | 注册IO |
| [service(path, io, opt)](#service) | 注册RPC服务 |
| [GET(path, io, opt)](#GET)         | 注册GET服务 |
| [POST(path, io, opt)](#POST)       | 注册POST服务 |
| [PUT(path, io, opt)](#PUT)         | 注册PUT服务 |
| [PATCH(path, io, opt)](#PATCH)     | 注册PATCH服务 |
| [DELETE(path, io, opt)](#DELETE)   | 注册DELETE服务 |


##### ``app.config(name, value)`` {#config}
```js
app.config('port', 80)
```
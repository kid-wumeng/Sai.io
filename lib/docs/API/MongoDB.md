# Sai.MongoDB


## MongoDB
| 方法原型 | 描述 |
| --- | --- |
| [col(name)](#col) | 选择集合 |


## Collection
| 方法原型 | 描述 |
| --- | --- |
| [findOne(query, opt)](#findOne)               | 单文档查询 |
| [find(query, opt)](#find)                     | 多文档查询 |
| [count(query, opt)](#count)                   | 文档数量统计 |
| [insert(data, opt)](#insert)                  | 单文档添加 |
| [insertMany(data, opt)](#insertMany)          | 多文档添加 |
| [update(query, data, opt)](#update)           | 单文档更新 |
| [updateMany(query, data, opt)](#updateMany)   | 多文档更新 |
| [remove(query, opt)](#remove)                 | 单文档软删除 |
| [removeMany(query, opt)](#removeMany)         | 多文档软删除 |
| [removeHard(query, opt)](#removeHard)         | 单文档硬删除 |
| [removeManyHard(query, opt)](#removeManyHard) | 多文档硬删除 |
| [restore(query, opt)](#restore)               | 单文档恢复 |
| [restoreMany(query, opt)](#restoreMany)       | 多文档恢复 |
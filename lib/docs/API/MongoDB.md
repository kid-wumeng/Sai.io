# Sai.MongoDB


## MongoDB
| 方法原型 | 描述 |
| --- | --- |
| [col( name )](#col) | 选择集合 |


## Collection
| 方法原型 | 描述 |
| --- | --- |
| [findOne( [query], [options] )](#findOne)               | 单文档查询 |
| [find( [query], [options] )](#find)                     | 多文档查询 |
| [count( [query], [options] )](#count)                   | 文档数量统计 |
| [insert( data, [options] )](#insert)                    | 单文档添加 |
| [insertMany( datas, [options] )](#insertMany)           | 多文档添加 |
| [update( query, data, [options] )](#update)             | 单文档更新 |
| [updateMany( query, data, [options] )](#updateMany)     | 多文档更新 |
| [remove( [query], [options] )](#remove)                 | 单文档软删除 |
| [removeMany( [query], [options] )](#removeMany)         | 多文档软删除 |
| [removeHard( [query], [options] )](#removeHard)         | 单文档硬删除 |
| [removeManyHard( [query], [options] )](#removeManyHard) | 多文档硬删除 |
| [restore( [query], [options] )](#restore)               | 单文档恢复 |
| [restoreMany( [query], [options] )](#restoreMany)       | 多文档恢复 |
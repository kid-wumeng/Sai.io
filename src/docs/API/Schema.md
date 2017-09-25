# Sai.Schema


## Schema
| 方法原型 | 描述 |
| --- | --- |
| [rule(name, options)](#rule)  | 注册规则 |
| [check(data, [path])](#check) | 设置需要验证的数据 |


## Checker
| 方法原型 | 描述 |
| --- | --- |
| [must([hint])](#must)                | 存在性验证，即不为``undefined``或``null`` |
| [type(...types, [hint])](#type)      | 类型验证 |
| [enum(...enums, [hint])](#type)      | 枚举验证 |
| [min(min, [hint])](#min)             | 最小值验证 |
| [max(max, [hint])](#max)             | 最大值验证 |
| [format(...format, [hint])](#format) | 格式验证 |
| [verify(fn, [hint])](#verify)        | 自定义验证 |
| [rule(name, [hint])](#rule)          | 预设规则集验证 |
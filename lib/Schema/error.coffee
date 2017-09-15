helper = require('../helper')



exports.throw = (error={}) =>
  error.status ?= 400
  helper.throw(error)



exports.Rule_Not_Found = ({ ruleName }) =>
  @throw({
    status: 404
    code: 1101
    zh_message: "规则 #{ruleName} 未找到，是不是没用 schema.rule() 注册？"
    data: {ruleName}
  })


exports.Check_Must_Failure = ({ value }, message) =>
  @throw({
    code: 1101
    message: message
    zh_message: "不能为空，当前：#{value}"
    data: {value}
  })


exports.Check_Type_Failure = ({ value, type }, message) =>
  @throw({
    code: 1101
    message: message
    zh_message: "类型不正确，预期类型：#{type.name}"
    data: {value, type}
  })


exports.Check_Enum_Failure = ({ value, enums }, message) =>
  @throw({
    code: 1101
    message: message
    zh_message: "值不在枚举范围内，当前值：#{value}，允许的值：#{enums.join(', ')}"
    data: {value, enums}
  })


exports.Check_Number_Min_Failure = ({ value, min }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "数值太小，当前：#{value}，必须 ≥ #{min}"
    data: {value, min}
  })


exports.Check_Number_Max_Failure = ({ value, max }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "数值太大，当前：#{value}，必须 ≤ #{max}"
    data: {value, max}
  })


exports.Check_String_Min_Failure = ({ value, size, min }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "字符串的长度太小，当前：#{size}，必须 ≥ #{min}"
    data: {value, size, min}
  })


exports.Check_String_Max_Failure = ({ value, size, max }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "字符串的长度太大，当前：#{size}，必须 ≤ #{max}"
    data: {value, size, max}
  })


exports.Check_Buffer_Min_Failure = ({ value, size, min }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "Buffer数据太小，当前：#{size}，必须 ≥ #{min}"
    data: {size, min}
  })


exports.Check_Buffer_Max_Failure = ({ value, size, max }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "Buffer数据太大，当前：#{size}，必须 ≤ #{max}"
    data: {size, max}
  })


exports.Check_Date_Min_Failure = ({ value, min }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "日期太小，当前：#{value.toLocaleString()}，必须 ≥ #{min.toLocaleString()}"
    data: {value, min}
  })


exports.Check_Date_Max_Failure = ({ value, max }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "日期太大，当前：#{value.toLocaleString()}，必须 ≤ #{max.toLocaleString()}"
    data: {value, max}
  })


exports.Check_MIME_Failure = ({ value, mime, mimes }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "不是允许的文件类型，当前文件的MIME：#{mime}，允许的MIME：#{mimes.join(', ')}"
    data: {mime, mimes}
  })


exports.Check_Format_Failure = ({ value, formats }, message) =>
  @throw({
    code: 1102
    message: message
    zh_message: "值的格式不正确，需求格式：#{formats.join(' | ')}，当前值：#{value}"
    data: {value, formats}
  })
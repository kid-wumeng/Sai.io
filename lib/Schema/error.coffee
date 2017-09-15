helper = require('../helper')


exports.Check_Must_Failure = ({ value }, message) =>
  helper.throw({
    status: 404
    code: 1101
    message: message
    zh_message: "值不能为空，当前：#{value}"
    data: {value}
  })


exports.Check_Number_Min_Failure = ({ value, min }, message) =>
  helper.throw({
    status: 404
    code: 1102
    message: message
    zh_message: "值太小，当前：#{value}，必须 ≥ #{min}"
    data: {value, min}
  })


exports.Check_Number_Max_Failure = ({ value, max }, message) =>
  helper.throw({
    status: 404
    code: 1102
    message: message
    zh_message: "值太大，当前：#{value}，必须 ≤ #{max}"
    data: {value, max}
  })


exports.Check_String_Min_Failure = ({ value, size, min }, message) =>
  helper.throw({
    status: 404
    code: 1102
    message: message
    zh_message: "值的长度太小，当前：#{size}，必须 ≥ #{min}"
    data: {value, size, min}
  })


exports.Check_String_Max_Failure = ({ value, size, max }, message) =>
  helper.throw({
    status: 404
    code: 1102
    message: message
    zh_message: "值的长度太大，当前：#{size}，必须 ≤ #{max}"
    data: {value, size, max}
  })
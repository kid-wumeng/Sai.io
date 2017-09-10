module.exports = ({code, en_message, zh_message, data}) ->
  error = new Error()
  error.code       = code       ? 0
  error.en_message = en_message ? ''
  error.zh_message = zh_message ? ''
  error.data       = data       ? {}
  throw error
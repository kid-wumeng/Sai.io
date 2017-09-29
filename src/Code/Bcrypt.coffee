bcrypt = require('bcrypt-nodejs')


module.exports = class Bcrypt


  encode: (data) =>
    return new Promise (resolve, reject) ->
      bcrypt.genSalt null, (error, salt) ->
        if(error) then reject(error)
        else
          bcrypt.hash data, salt, null, (error, hash) ->
            if(error) then reject(error) else resolve(hash)


  compare: (data, hash) =>
    return new Promise (resolve, reject) ->
      bcrypt.compare data, hash, (error, result) ->
        if(error) then reject(error) else resolve(result)
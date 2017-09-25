const path = require('path');

module.exports = {
  entry: './src/RemoteApp/index.w3c',

  output: {
    path: path.resolve(__dirname, 'lib'),
    filename: 'w3c.js',
    library: 'Sai',
    libraryTarget: 'umd'
  },

  module: {
    rules: [{
      test: /\.coffee$/,
      loader: 'coffee-loader'
    }]
  },

  resolve: {
    extensions: ['.js', '.coffee']
  },

  externals: {
    ws: 'WebSocket'
  }
}
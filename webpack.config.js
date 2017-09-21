const path = require('path');

module.exports = {
  entry: './lib/RemoteApp/index.w3c',

  output: {
    path: path.resolve(__dirname, 'dist'),
    filename: 'remote-app.js',
    library: 'Sai',
    libraryTarget: 'umd'
  },

  module: {
    rules: [{
      test: /\.coffee$/,
      exclude: [
        path.resolve(__dirname, "app/demo-files")
      ],
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
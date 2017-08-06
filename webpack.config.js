let path = require('path')
let HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
  entry: './src/coffee/Main.coffee',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'build')
  },
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.coffee$/,
        use: [
          {
            loader: 'coffee-loader',
            options: { sourceMap: true }
          }
        ]
      },
      {
        test: /\.(sass|scss)$/,
        use: [ 'style-loader', 'css-loader', 'sass-loader?sourceMap' ]
      },
      {
        test: /\.(jade|pug)$/,
        use: ['html-loader', 'pug-html-loader']
      },
      {
        test: /\.(jpe?g|gif|png|svg|woff|ttf|wav|mp3)$/,
        use: 'file-loader'
      }
    ]
  },
  resolve: {
    extensions: ['.js', '.coffee', '.sass']
  },
  plugins: [
    new HtmlWebpackPlugin({
      template: './src/index.pug'
    })
  ]
}

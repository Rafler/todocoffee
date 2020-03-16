const path = require('path');


const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  mode: "development",
  module: {
    rules: [    {
      test: /\.css$/,
      use: ['style-loader', 'css-loader']
    },
      {
        test: /\.coffee$/,
        use: [
          {
            loader: 'coffee-loader',
          }
        ]
      }
    ]
  },
  entry: {
    bundle:['./src/coffee/TodosList.coffee', './src/coffee/TodoServices.coffee'],
  },
  resolve: {
    extensions: [".web.coffee", ".web.js", ".coffee", ".js"]
  },
  output: {
    filename: '[name].js',
  },
  plugins: [
    new HtmlWebpackPlugin({
                            hash: true,
                            filename: './index.html',
                            template: './index.html',
                          })]
};

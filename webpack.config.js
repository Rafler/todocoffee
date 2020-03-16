const path = require('path');


const HtmlWebpackPlugin = require('html-webpack-plugin');

module.exports = {
  mode: "development",
  module: {
    rules: [    {
      test: /\.css$/,
      use: ['style-loader', 'css-loader']
    }],
  },
  entry: {
    bundle:['./src/js/TodosList.js', './src/js/TodoServices.js'],
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

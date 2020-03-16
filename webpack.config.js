const path = require('path');

module.exports = {
  mode: "development",
  entry: {
    bundle:['./src/js/TodosList.js', './src/js/Todo.js', './src/js/TodoServices.js']
  },
  output: {
    filename: '[name].js'
  }
};

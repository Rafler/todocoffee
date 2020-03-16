const webpackConfig = require('./webpack.config.js');

module.exports = function(grunt) {

  // Project configuration.
  grunt.initConfig({
                     pkg: grunt.file.readJSON('package.json'),
                     uglify: {
                       options: {
                         banner: '/*! <%= pkg.name %> <%= grunt.template.today("yyyy-mm-dd") %> */\n'
                       },
                       build: {
                         src: 'src/<%= pkg.name %>.js',
                         dest: 'build/<%= pkg.name %>.min.js'
                       }
                     },
                     webpack: {
                       options: {
                         stats: !process.env.NODE_ENV || process.env.NODE_ENV === 'development',
                       },
                       prod: webpackConfig,
                       dev: Object.assign({ watch: true }, webpackConfig),
                     },
                     coffee: {
                       build: {
                         expand: true,
                         flatten: true,
                         cwd: './src/coffee',
                         src: ['*.coffee'],
                         dest: './src/js',
                         ext: '.js'
                       }
                     },
                     watch: {
                       coffee: {
                         files: ['src/**/*.coffee'],
                         tasks: ['coffee', 'webpack'],
                       },
                     },
                   });

  // Load the plugin that provides the "uglify" task.
  grunt.loadNpmTasks('grunt-contrib-uglify');

  // Default task(s).
  grunt.registerTask('default', ['uglify']);

  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-webpack');
  grunt.loadNpmTasks('grunt-contrib-watch');
};

/**
 * Adds the git hash to the bundled asset files
 * to prevent browser caching issues in
 * production
 */

 var git = require('git-rev')

module.exports = function(grunt) {

  git.short(function(hash) {

    var files = {}
    files['.tmp/public/min/productionAdmin.' + hash + '.min.js'] = '.tmp/public/min/productionAdmin.min.js'
    files['.tmp/public/min/productionAdmin.' + hash + '.min.css'] = '.tmp/public/min/productionAdmin.min.css'
    files['.tmp/public/min/productionPublic.' + hash + '.min.js'] = '.tmp/public/min/productionPublic.min.js'
    files['.tmp/public/min/productionPublic.' + hash + '.min.css'] = '.tmp/public/min/productionPublic.min.css'

    grunt.config.set('rename', {
      dist: {
        files: files
      }
    })

  })

  grunt.loadNpmTasks('grunt-rename')
};

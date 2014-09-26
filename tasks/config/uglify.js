/**
 * Minify files with UglifyJS.
 *
 * ---------------------------------------------------------------
 *
 * Minifies client-side javascript `assets`.
 *
 * For usage docs see:
 * 		https://github.com/gruntjs/grunt-contrib-uglify
 *
 */
module.exports = function(grunt) {

	grunt.config.set('uglify', {
		dist: {
      files: {
       '.tmp/public/min/productionPublic.min.js': '.tmp/public/concat/productionPublic.js',
       '.tmp/public/min/productionAdmin.min.js': '.tmp/public/concat/productionAdmin.js' 
      }
		}
	});

	grunt.loadNpmTasks('grunt-contrib-uglify');
};

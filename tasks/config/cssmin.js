/**
 * Compress CSS files.
 *
 * ---------------------------------------------------------------
 *
 * Minifies css files and places them into .tmp/public/min directory.
 *
 * For usage docs see:
 * 		https://github.com/gruntjs/grunt-contrib-cssmin
 */
module.exports = function(grunt) {

	grunt.config.set('cssmin', {
		dist: {
      files: {
        '.tmp/public/min/productionPublic.min.css': '.tmp/public/concat/productionPublic.css',
        '.tmp/public/min/productionAdmin.min.css': '.tmp/public/concat/productionAdmin.css', 
      }
		}
	});

	grunt.loadNpmTasks('grunt-contrib-cssmin');
};

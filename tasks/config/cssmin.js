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
			src: ['.tmp/public/concat/productionPublic.css', '.tmp/public/concat/productionAdmin.css'],
			dest: '.tmp/public/min/',
      ext: '.min.css'
		}
	});

	grunt.loadNpmTasks('grunt-contrib-cssmin');
};

/**
 * Compile CoffeeScript files to JavaScript.
 *
 * ---------------------------------------------------------------
 *
 * Compiles coffeeScript files from `assest/js` into Javascript and places them into
 * `.tmp/public/js` directory.
 *
 * For usage docs see:
 * 		https://github.com/gruntjs/grunt-contrib-coffee
 */
module.exports = function(grunt) {

	grunt.config.set('coffee', {
		dev: {
			options: {
				bare: true,
				sourceMap: true,
				sourceRoot: './'
			},
			files: [{
				expand: true,
				cwd: 'assets/public/js',
				src: ['**/*.coffee'],
				dest: '.tmp/public/public/js/',
				ext: '.js'
			}, {
				expand: true,
				cwd: 'assets/admin/js',
				src: ['**/*.coffee'],
				dest: '.tmp/public/admin/js/',
				ext: '.js'
			}]
		}
	});

	grunt.loadNpmTasks('grunt-contrib-coffee');
};

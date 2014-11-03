/**
 * Concatenate files.
 *
 * ---------------------------------------------------------------
 *
 * Concatenates files javascript and css from a defined array. Creates concatenated files in
 * .tmp/public/contact directory
 * [concat](https://github.com/gruntjs/grunt-contrib-concat)
 *
 * For usage docs see:
 * 		https://github.com/gruntjs/grunt-contrib-concat
 */
module.exports = function(grunt) {

	grunt.config.set('concat', {
		options: {
			separator: ';'
		},
		publicJS: {
			src: require('../pipeline').publicJSFilesToInject,
			dest: '.tmp/public/concat/productionPublic.js'
		},
		adminJS: {
			src: require('../pipeline').adminJSFilesToInject,
			dest: '.tmp/public/concat/productionAdmin.js'
		},

		publicCSS: {
			src: require('../pipeline').publicCSSFilesToInject,
			dest: '.tmp/public/concat/productionPublic.css'
		},
		adminCSS: {
			src: require('../pipeline').adminCSSFilesToInject,
			dest: '.tmp/public/concat/productionAdmin.css'
		}
	});

	grunt.loadNpmTasks('grunt-contrib-concat');
};

module.exports = function (grunt) {
	grunt.registerTask('prod', [
		'compileAssets',
		'concat',
		'uglify',
		'cssmin',
		'rename',
		'sails-linker:prodPublicJs',	
		'sails-linker:prodAdminJs',
		'sails-linker:prodPublicStyles',
		'sails-linker:prodAdminStyles',
		'sails-linker:devAdminTpl'
	]);
};

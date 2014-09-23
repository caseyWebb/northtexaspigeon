module.exports = function (grunt) {
	grunt.registerTask('prod', [
		'compileAssets',
		'concat',
		'uglify',
		'cssmin',
		'sails-linker:prodPublicJs',	
		'sails-linker:prodAdminJs',
		'sails-linker:prodPublicStyles',
		'sails-linker:prodAdminStyles',
		'sails-linker:devPublicTpl',
		'sails-linker:devAdminTpl'
	]);
};

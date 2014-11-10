module.exports = function (grunt) {
	grunt.registerTask('linkAssets', [
		'sails-linker:devPublicJs',
    'sails-linker:devAdminJs',
		'sails-linker:devPublicStyles',
    'sails-linker:devAdminStyles',
    'sails-linker:devAdminTpl'
	]);
};

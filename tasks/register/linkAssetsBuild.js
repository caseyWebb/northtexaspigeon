module.exports = function (grunt) {
	grunt.registerTask('linkAssetsBuild', [
		'sails-linker:devPublicJsRelative',
    'sails-linker:devAdminJsRelative',
		'sails-linker:devPublicStylesRelative',
    'sails-linker:devAdminStylesRelative',
    'sails-linker:devAdminTpl'
	]);
};

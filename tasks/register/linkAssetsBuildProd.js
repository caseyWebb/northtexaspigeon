module.exports = function (grunt) {
	grunt.registerTask('linkAssetsBuildProd', [
		'sails-linker:prodPublicJsRelative',
    'sails-linker:prodAdminJsRelative',
		'sails-linker:prodPublicStylesRelative',
    'sails-linker:prodAdminStylesRelative',
    'sails-linker:devAdminTpl'
	]);
};

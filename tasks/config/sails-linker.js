/**
 * Autoinsert script tags (or other filebased tags) in an html file.
 *
 * ---------------------------------------------------------------
 *
 * Automatically inject <script> tags for javascript files and <link> tags
 * for css files.  Also automatically links an output file containing precompiled
 * templates using a <script> tag.
 *
 * For usage docs see:
 * 		https://github.com/Zolmeister/grunt-sails-linker
 *
 */
module.exports = function(grunt) {

	grunt.config.set('sails-linker', {

		devPublicJs: {
			options: {
				startTag: '// SCRIPTS',
				endTag: '// SCRIPTS END',
				fileTmpl: 'script(src="%s")',
				appRoot: '.tmp/public'
			},
			files: {
				'views/linker/public/scripts.jade': require('../pipeline').publicJSFilesToInject
			}
		},

		devAdminJs: {
			options: {
				startTag: '// SCRIPTS',
				endTag: '// SCRIPTS END',
				fileTmpl: 'script(src="%s")',
				appRoot: '.tmp/public'
			},
			files: {
				'views/linker/admin/scripts.jade': require('../pipeline').adminJSFilesToInject
			}
		},

		devPublicJsRelative: {
			options: {
				startTag: '// SCRIPTS',
				endTag: '// SCRIPTS END',
				fileTmpl: 'script(src="%s")',
				appRoot: '.tmp/public',
				relative: true
			},
			files: {
				'views/linker/public/scripts.jade': require('../pipeline').publicJSFilesToInject
			}
		},

		devAdminJsRelative: {
			options: {
				startTag: '// SCRIPTS',
				endTag: '// SCRIPTS END',
				fileTmpl: 'script(src="%s")',
				appRoot: '.tmp/public',
				relative: true
			},
			files: {
				'views/linker/admin/scripts.jade': require('../pipeline').adminJSFilesToInject
			}
		},

		prodPublicJs: {
			options: {
				startTag: '// SCRIPTS',
				endTag: '// SCRIPTS END',
				fileTmpl: 'script(src="%s")',
				appRoot: '.tmp/public'
			},
			files: {
				'views/linker/public/scripts.jade': ['.tmp/public/min/productionPublic.*.min.js']
			}
		},

		prodAdminJs: {
			options: {
				startTag: '// SCRIPTS',
				endTag: '// SCRIPTS END',
				fileTmpl: 'script(src="%s")',
				appRoot: '.tmp/public'
			},
			files: {
				'views/linker/admin/scripts.jade': ['.tmp/public/min/productionAdmin.*.min.js']
			}
		},

		prodPublicJsRelative: {
			options: {
				startTag: '// SCRIPTS',
				endTag: '// SCRIPTS END',
				fileTmpl: 'script(src="%s")',
				appRoot: '.tmp/public',
				relative: true
			},
			files: {
				'views/linker/public/scripts.jade': ['.tmp/public/min/productionPublic.*.min.js']
			}
		},

		prodAdminJsRelative: {
			options: {
				startTag: '// SCRIPTS',
				endTag: '// SCRIPTS END',
				fileTmpl: 'script(src="%s")',
				appRoot: '.tmp/public',
				relative: true
			},
			files: {
				'views/linker/admin/scripts.jade': ['.tmp/public/min/productionAdmin.*.min.js']
			}
		},

		/////////////////////////////////////////////////////////////////////////////////////

		devPublicStyles: {
			options: {
				startTag: '// STYLES',
				endTag: '// STYLES END',
				fileTmpl: 'link(rel="stylesheet", href="%s")',
				appRoot: '.tmp/public'
			},

			files: {
				'views/linker/public/styles.jade': require('../pipeline').publicCSSFilesToInject
			}
		},

		devAdminStyles: {
			options: {
				startTag: '// STYLES',
				endTag: '// STYLES END',
				fileTmpl: 'link(rel="stylesheet", href="%s")',
				appRoot: '.tmp/public'
			},

			files: {
				'views/linker/admin/styles.jade': require('../pipeline').adminCSSFilesToInject
			}
		},

		devPublicStylesRelative: {
			options: {
				startTag: '// STYLES',
				endTag: '// STYLES END',
				fileTmpl: 'link(rel="stylesheet", href="%s")',
				appRoot: '.tmp/public',
				relative: true
			},

			files: {
				'views/linker/public/styles.jade': require('../pipeline').publicCSSFilesToInject
			}
		},

		devAdminStylesRelative: {
			options: {
				startTag: '// STYLES',
				endTag: '// STYLES END',
				fileTmpl: 'link(rel="stylesheet", href="%s")',
				appRoot: '.tmp/public',
				relative: true
			},

			files: {
				'views/linker/admin/styles.jade': require('../pipeline').adminCSSFilesToInject
			}
		},

		prodPublicStyles: {
			options: {
				startTag: '// STYLES',
				endTag: '// STYLES END',
				fileTmpl: 'link(rel="stylesheet", href="%s")',
				appRoot: '.tmp/public'
			},
			files: {
				'views/linker/public/styles.jade': ['.tmp/public/min/productionPublic.*.min.css']
			}
		},

		prodAdminStyles: {
			options: {
				startTag: '// STYLES',
				endTag: '// STYLES END',
				fileTmpl: 'link(rel="stylesheet", href="%s")',
				appRoot: '.tmp/public'
			},
			files: {
				'views/linker/admin/styles.jade': ['.tmp/public/min/productionAdmin.*.min.css']
			}
		},

		prodPublicStylesRelative: {
			options: {
				startTag: '// STYLES',
				endTag: '// STYLES END',
				fileTmpl: 'link(rel="stylesheet", href="%s")',
				appRoot: '.tmp/public',
				relative: true
			},
			files: {
				'views/linker/public/styles.jade': ['.tmp/public/min/productionPublic.*.min.css']
			}
		},

		prodAdminStylesRelative: {
			options: {
				startTag: '// STYLES',
				endTag: '// STYLES END',
				fileTmpl: 'link(rel="stylesheet", href="%s")',
				appRoot: '.tmp/public',
				relative: true
			},
			files: {
				'views/linker/admin/styles.jade': ['.tmp/public/min/productionAdmin.*.min.css']
			}
		},

		//////////////////////////////////////////////////////////////////////////////////

		// Bring in JST template object
		devAdminTpl: {
			options: {
				startTag: '// TEMPLATES',
				endTag: '// TEMPLATES END',
				fileTmpl: 'script(type="text/javascript", src="%s")',
				appRoot: '.tmp/public'
			},
			files: {
				'views/linker/admin/templates.jade': ['.tmp/public/adminJST.js']
			}
		}
	});

	grunt.loadNpmTasks('grunt-sails-linker');
};

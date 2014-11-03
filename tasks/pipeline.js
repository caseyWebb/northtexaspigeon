/**
 * grunt/pipeline.js
 *
 * The order in which your css, javascript, and template files should be
 * compiled and linked from your views and static HTML files.
 *
 * (Note that you can take advantage of Grunt-style wildcard/glob/splat expressions
 * for matching multiple files.)
 */


// CSS files to inject in order
var publicCSSFilesToInject = [
  
  'bower_components/foundation/css/normalize.css',
  'bower_components/foundation/css/foundation.css',

  'public/styles/**/*.css',
  'shared/styles/**/*.css'
];

var adminCSSFilesToInject = [

  'bower_components/foundation/css/normalize.css',
  'bower_components/foundation/css/foundation.css',
  'bower_components/animate.css/animate.css',

  'admin/styles/**/*.css',
  'shared/styles/**/*.css'
];


// Client-side javascript files to inject in order
var publicJSFilesToInject = [

  'bower_components/jquery/dist/jquery.js',
  'bower_components/fastclick/lib/fastclick.js',
  'bower_components/history.js/scripts/bundled/html4+html5/jquery.history.js',
  
  'public/js/**/*.js',
  'shared/js/**/*.js'
];

var adminJSFilesToInject = [

  'bower_components/jquery/dist/jquery.js',
  'bower_components/ng-file-upload-html5-shim.js',
  'bower_components/angular/angular.js',
  'bower_components/angular-route/angular-route.js',
  'bower_components/angular-ui-router/release/angular-ui-router.js',
  'bower_components/angular-animate/angular-animate.js',
  'bower_components/angular-sanitize/angular-sanitize.js',
  'bower_components/angular-elastic/elastic.js',
  'bower_components/angularjs-toaster/toaster.js',
  'bower_components/lodash/dist/lodash.js',
  'bower_components/angular-foundation/mm-foundation-tpls.js',
  'bower_components/marked/lib/marked.js',
  'bower_components/angular-marked/angular-marked.js',
  'bower_components/ng-context-menu/dist/ng-context-menu.js',
  'bower_components/ng-file-upload/angular-file-upload.js',
  'bower_components/ngInfiniteScroll/build/ng-infinite-scroll.js',
  'bower_components/moment/moment.js',
  'bower_components/angular-moment/angular-moment.js',

  'admin/js/**/*.js',
  'shared/js/**/*.js'
];


// Client-side HTML templates are injected using the sources below
// The ordering of these templates shouldn't matter.
// (uses Grunt-style wildcard/glob/splat expressions)
//
// By default, Sails uses JST templates and precompiles them into
// functions for you.  If you want to use jade, handlebars, dust, etc.,
// with the linker, no problem-- you'll just want to make sure the precompiled
// templates get spit out to the same file.  Be sure and check out `tasks/README.md`
// for information on customizing and installing new tasks.

var publicTemplateFilesToInject = [
  'public/templates/**/*.html'
];

var adminTemplateFilesToInject = [
  'admin/templates/**/*.html'
];


// Prefix relative paths to source files so they point to the proper locations
// (i.e. where the other Grunt tasks spit them out, or in some cases, where
// they reside in the first place)
module.exports.publicCSSFilesToInject = publicCSSFilesToInject.map(function(path) {
  return '.tmp/public/' + path;
});
module.exports.adminCSSFilesToInject = adminCSSFilesToInject.map(function(path) {
  return '.tmp/public/' + path;
});

module.exports.publicJSFilesToInject = publicJSFilesToInject.map(function(path) {
  return '.tmp/public/' + path;
});
module.exports.adminJSFilesToInject = adminJSFilesToInject.map(function(path) {
  return '.tmp/public/' + path;
});

module.exports.publicTemplateFilesToInject = publicTemplateFilesToInject.map(function(path) {
  return 'assets/' + path;
});
module.exports.adminTemplateFilesToInject = adminTemplateFilesToInject.map(function(path) {
  return 'assets/' + path;
});
###
Route Mappings
(sails.config.routes)

Your routes map URLs to views and controllers.

If Sails receives a URL that doesn't match any of the routes below,
it will check for matching files (images, scripts, stylesheets, etc.)
in your assets directory.  e.g. `http://localhost:1337/images/foo.jpg`
might match an image file: `/assets/images/foo.jpg`

Finally, if those don't match either, the default 404 handler is triggered.
See `api/responses/notFound.js` to adjust your app's 404 logic.

Note: Sails doesn't ACTUALLY serve stuff from `assets`-- the default Gruntfile in Sails copies
flat files from `assets` to `.tmp/public`.  This allows you to do things like compile LESS or
CoffeeScript for the front-end.

For more information on configuring custom routes, check out:
http://sailsjs.org/#/documentation/concepts/Routes/RouteTargetSyntax.html
###

module.exports.routes =

  'GET /': 'Homepage.homepage'

  'GET /login': { view: 'login' }
  'GET /logout': 'Auth.logout'
  'GET /join': { view: 'join' }
  'GET /disclaimer': { view: 'disclaimer' }
  'GET /contact': { view: 'contact' }

  'GET /sitemap.xml': 'Sitemap.sitemap'

  'GET /category/:category': 'Article.findByCategory'

  'GET /tag': 'TagController.find'
  'GET /tag/:tag': 'TagController.findOne'
  
  'POST /article/:id/comment': 'Article.comment'
  'POST /picture/:id/comment': 'Picture.comment'
  'POST /video/:id/comment': 'Video.comment'

  'POST /emailthread/:threadID/reply': 'EmailThread.reply'

  # legacy routes
  'GET /articles/:id': 'Article.findOne'
  'GET /pictures/:id': 'Picture.findOne'
  'GET /videos/:id': 'Video.findOne'

  # passthrough to angular admin panel
  'GET /admin*':
    view: 'admin'
    skipAssets: true
    policy: 'isAuthenticated'

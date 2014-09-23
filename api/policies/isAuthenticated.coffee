###
 isAuthenticated

 @module      :: Policy
 @description :: Simple policy to allow any authenticated user
                 Assumes that your login action in one of your controllers sets `req.session.user = user;`
 @docs        :: http://sailsjs.org/#!documentation/policies
###
 
module.exports = (req, res, next) ->

  # User is allowed, proceed to the next policy, 
  # or if this is the last policy, the controller
  if (req.session.user?)
    return next()

  # User is not allowed
  # (default res.forbidden() behavior can be overridden in `config/403.js`)
  req.flash('loginErr', 'You must be logged in to access this page')
  req.flash('redirect', req.url)
  return res.redirect('/login?')


 # AuthController
 #
 # @description :: Server-side logic for managing auths
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 

  login: (req, res) ->
    bcrypt = require 'bcrypt-nodejs'

    User.findOneByEmail(req.param('email')).exec (err, user) ->
      return res.serverError(err) if err

      if !user?
        req.flash('loginErr', 'User not found')
        return res.redirect('/login')

      bcrypt.compare req.param('password'), user.password, (err, matches) ->
        return res.serverError(err) if err

        if !matches
          req.flash('loginErr', 'Invalid password')
          return res.redirect('/login')

        req.session.user = 
          id: user.id
          isAdmin: user.isAdmin

        res.redirect(req.param('redirect') || '/admin')

  logout: (req, res) ->
    delete req.session.user
    res.redirect('/')
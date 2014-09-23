 # UserController
 #
 # @description :: Server-side logic for managing users
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =

  create: (req, res) ->
    SignupToken.findOneByValue(req.param('token')).exec (err, token) ->
      return res.serverError(err) if err
      return res.redirect('/join') if !token?

      if (req.param('password') != req.param('passwordConf'))
        req.flash('passMismatch', 'Passwords did not match')
        return res.redirect("/join?token=#{token.value}") 

      User.create
        name: req.param('name')
        pseudonym: req.param('pseudonym')
        email: req.param('email')
        password: req.param('password')

      .exec (err, user) ->
        return res.serverError(err) if err

        req.session.user = 
          id: user.id
          isAdmin: user.isAdmin

        res.redirect('/admin')
        token.destroy()

  invite: (req, res) ->
    User.invite req.param('emails'), (err, digest) ->
      return res.serverError(err) if err
      res.ok(digest)

  current: (req, res) ->
    User.findOne(req.session.user.id).exec (err, user) ->
      return res.serverError(err) if err

      res.json(user)

  resetPassword: (req, res) ->
    User.resetPassword req.param('email'), (err) ->
      if err
        if err.status
          return res.send(err.status, err)
        else
          return res.serverError(err)

      res.ok()
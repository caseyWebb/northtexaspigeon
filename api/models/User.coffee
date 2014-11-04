 # User.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

bcrypt      = require 'bcrypt-nodejs'

module.exports =

  attributes:

    email:
      type: 'email'
      required: true
      unique: true

    password:
      type: 'string'
      required: true

    name:
      type: 'string'
      required: true

    pseudonym:
      type: 'string'
      required: true

    about:
      type: 'string'

    isAdmin:
      type: 'boolean'
      defaultsTo: false

    isDisabled:
      type: 'boolean'
      defaultsTo: false

    toJSON: ->
     user = @toObject()
     delete user.password
     return user

  afterValidation: (user, cb) ->
    if (user.password?) 
      bcrypt.genSalt 10, (err, salt) ->
        bcrypt.hash user.password, salt, null, (err, hash) ->
          cb(err) if err

          user.password = hash
          cb(null, user)
    else
      cb(null, user)

  invite: (emails, cb) ->
    Mailer.getTemplate 'invite', (err, template) ->
      return cb(err) if err?
      
      for email in emails
        SignupToken.create().exec (err, token) ->
          return cb(err) if err?

          Mailer.send 'Welcome to the Pigeon!', template({ email: email, token: token.value }), [email], 'no-reply', (err, digest) ->
            cb(err, digest)

  resetPassword: (userEmail, cb) ->
    User.findOneByEmail(userEmail).exec (err, user) ->
      return cb(err) if err?
      return cb({ status: 404, error: 'User not found' }) if !user?

      require('crypto').randomBytes 8, (ex, buf) ->
        newPass = buf.toString('hex')
        user.password = newPass

        user.save (err, user) ->
          return cb(err) if err?
          
          Mailer.getTemplate 'forgotPassword', (err, template) ->
            return cb(err) if err?

            Mailer.send 'Password Reset', template({ password: newPass }), [user.email], 'no-reply', (err, digest) ->
              cb(err, digest)

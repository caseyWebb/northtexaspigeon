###
 * Bootstrap
 * (sails.config.bootstrap)
 *
 * An asynchronous bootstrap function that runs before your Sails app gets lifted.
 * This gives you an opportunity to set up your data model, run jobs, or perform some special logic.
 *
 * For more information on bootstrapping your app, check out:
 * http://sailsjs.org/#/documentation/reference/sails.config/sails.config.bootstrap.html
###

prompt  = require 'prompt'


module.exports.bootstrap = (cb) ->

  User.count().exec (err, numUsers) ->
    if (numUsers == 0)
      sails.log.error "No users found. Please create first user..."

      prompt.start()
      prompt.get
        properties:
          name: required: true
          pseudonym: required: true
          email: required: true
          password:
            required: true
            hidden: true
        (err, u) ->
          u.isAdmin = true
          User.create(u).exec (err) ->
            if (err?)
              return sails.log.error "Error creating user: #{err}\n\nShut down the server and try again..."
            else
              sails.log.info "User created successfully"


  cb()

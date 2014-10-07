 # SignupToken.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models


module.exports =

  attributes:

    value:
      type: 'string'
      required: true

  beforeValidation: (token, cb) ->
    require('crypto').randomBytes 48, (ex, buf) ->
      token.value = buf.toString('hex')
      cb()


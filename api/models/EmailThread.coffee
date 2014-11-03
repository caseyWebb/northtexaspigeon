 # EmailThread.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

  attributes:

    mailbox:
      type: 'string'
      required: true

    theirEmail:
      type: 'string'
      required: true

    theirName:
      type: 'string'

    emails:
      collection: 'email'
      via: 'thread'

    readBy:
      type: 'array'
      defaultsTo: []
 # Email.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

  attributes:

    inbound:
      type: 'boolean'

    html:
      type: 'text'

    text:
      type: 'text'

    attachments:
      type: 'array'
      defaultsTo: []

    thread: {
      model: 'emailThread'
    }
 # Email.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

  attributes:

    html:
      type: 'text'

    text:
      type: 'text'

    from:
      type: 'string'
      required: true

    mailbox:
      type: 'string'
      required: true

    attachments:
      type: 'array'


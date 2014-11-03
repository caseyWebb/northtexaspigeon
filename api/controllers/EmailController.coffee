 # EmailController
 #
 # @description :: Server-side logic for managing emails
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 

  create: (req, res) ->

    mailinMsg = req.param('mailinMsg')

    req.file(mailinMsg.attachments).upload
      adapter: require('skipper-gridfs')
      uri: sails.config.connections.emailAttachments.uri
    , (err, attachments) ->
      console.log attachments
      res.send(attachments)


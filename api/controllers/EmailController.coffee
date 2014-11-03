 # EmailController
 #
 # @description :: Server-side logic for managing emails
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 

  create: (req, res) ->

    mailinMsg = req.param('mailinMsg')

    async.map mailinMsg.attachments || [],
      (attachment, cb) ->
        console.log attachment.fileName
        req.file(attachment.fileName).upload
          adapter: require('skipper-gridfs')
          uri: sails.config.connections.emailAttachments.uri
        , cb
      (err, attachments) ->
        console.log attachments
        res.send(attachments)


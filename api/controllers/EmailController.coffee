 # EmailController
 #
 # @description :: Server-side logic for managing emails
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 

  create: (req, res) ->

    Async.map req.param('attachments'),
      (attachment, cb) ->
        req.file(attachment.fileName).upload
          adapter: require('skipper-gridfs')
          uri: sails.config.connections.emailAttachments.uri
        , cb
      (err, attachments) ->
        res.send(attachments)


 # EmailController
 #
 # @description :: Server-side logic for managing emails
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 

  create: (req, res) ->

    mailinMsg = JSON.parse(req.param('mailinMsg'))

    async.map mailinMsg.attachments || [],
      (attachment, cb) ->
        cb(null, { fileName: attachment.fileName, file: req.param(attachment.fileName) })
      (err, attachments) ->
        console.log attachments
        res.send(attachments)


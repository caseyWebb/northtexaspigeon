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

        box = switch mailinMsg.from[0].split('@')[0].toLowerCase()
          when 'love' then 'kudos'
          when 'hate' then 'hatemail'
          when 'advertiseonthe' then 'advertisers'

        Email.create
          html: mailinMsg.html
          text: mailinMsg.text
          from: mailinMsg.from[0]
          mailbox: box
          attachments: attachments
        .exec (err, email) ->
          return res.serverError(err) if err?
          res.ok()
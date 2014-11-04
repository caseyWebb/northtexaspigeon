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

        box = switch mailinMsg.to[0].address.split('@')[0].toLowerCase()
          when 'love' then 'kudos'
          when 'hate' then 'hatemail'
          when 'advertiseonthe' then 'advertisers'
          else 'reject'

        if box == 'reject'
          return res.forbidden('Invalid recipient')

        EmailThread.findOrCreate
          mailbox: box
          theirEmail: mailinMsg.from[0].address
        ,
          mailbox: box
          theirEmail: mailinMsg.from[0].address
          theirName: mailinMsg.from[0].name
          
        .exec (err, thread) ->
          return res.serverError(err) if err?

          Email.create
            inbound: true
            html: mailinMsg.html
            text: mailinMsg.text
            attachments: attachments
            thread: thread
          .exec (err, email) ->
            return res.serverError(err) if err?
            res.ok()

          thread.readBy = []
          thread.save()

  unread: (req, res) ->

    mailboxes = ['kudos', 'hatemail', 'advertisers']
    unreadCounts = {}

    async.each mailboxes,

      (box, next) ->
        EmailThread.count
          readBy: { '!': [req.session.user.id] }
          mailbox: box
        .exec (err, unreadCount) ->
          unreadCounts[box] = unreadCount
          next(err)

      (err) ->
        return res.serverError(err) if err?
        res.json(unreadCounts)




 # EmailThreadController
 #
 # @description :: Server-side logic for managing emailthreads
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 

  find: (req, res) ->

    EmailThread.find().exec (err, threads) ->
      return res.serverError(err) if err?

      for thread in threads
        thread.unread = thread.readBy.indexOf(req.session.user.id) < 0

      res.json(threads)


  findOne: (req, res) ->

    EmailThread.findOne(req.param('id')).populate('emails').exec (err, thread) ->
      return res.serverError(err) if err?

      for message in thread.emails
        for attachment in message.attachments
          attachment.file = ''

      res.json(thread)

      thread.readBy.push(req.session.user.id)
      thread.save()

  reply: (req, res) ->

    EmailThread.findOne(req.param('threadID')).exec (err, thread) ->
      return res.serverError(err) if err?

      sendAs = switch thread.mailbox
          when 'kudos' then 'love'
          when 'hatemail' then 'hate'
          when 'advertisers' then 'advertiseonthe'

      Mailer.send "RE: #{thread.mailbox}", req.param('reply'), [thread.theirEmail], sendAs, (err, data) ->
        return res.serverError(err) if err?

        res.json(data)

        Email.create
          inbound: false
          text: req.param('reply')
          thread: thread
        .exec (err, email) ->
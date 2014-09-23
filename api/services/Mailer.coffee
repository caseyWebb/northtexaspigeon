nodemailer    = require 'nodemailer'
smtpPool      = require 'nodemailer-smtp-pool'
wellknown     = require 'nodemailer-wellknown'
_             = require 'lodash'
fs            = require 'fs'
handlebars    = require 'handlebars'

module.exports = Email = 
  
  send: (subject, message, recipients, cb) ->

    params =
      from: sails.config.email.from
      subject: subject
      html: message

    transporter = nodemailer.createTransport(smtpPool(sails.config.email.transportOptions))

    responseDigest = []
    sendResIfReady = _.after recipients.length, ->
      transporter.close()
      cb(responseDigest)

    addToDigest = (res) ->
      responseDigest.push(res)
      sendResIfReady()

    for recipient in recipients
      params.to = recipient
      transporter.sendMail params, (err, res) ->
        digestMessage =
          recipient: recipient
          status: if err then err else res
        addToDigest(digestMessage)

  getTemplate: (templateName, cb) ->
    fs.readFile "#{__dirname}/../../views/emails/#{templateName}.html", 'utf8', (err, html) ->
      cb(err, handlebars.compile(html))

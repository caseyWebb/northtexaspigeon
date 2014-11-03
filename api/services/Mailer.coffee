nodemailer    = require 'nodemailer'
smtpPool      = require 'nodemailer-smtp-pool'
wellknown     = require 'nodemailer-wellknown'
_             = require 'lodash'
fs            = require 'fs'
handlebars    = require 'handlebars'

module.exports = Email = 
  
  send: (subject, message, recipients, sendAs, cb) ->

    params =
      from: "North Texas Pigeon <#{sendAs}@northtexaspigeon.com>"
      to: recipients.join(', ')
      subject: subject
      html: message

    transporter = nodemailer.createTransport(smtpPool(sails.config.email.transportOptions))

    transporter.sendMail params, (err, res) ->
      transporter.close()
      cb(err, res)

  getTemplate: (templateName, cb) ->
    fs.readFile "#{__dirname}/../../views/emails/#{templateName}.html", 'utf8', (err, html) ->
      cb(err, handlebars.compile(html))

###
This module contains the receivers for uploading and resizing images.
You will need graphicsmagick installed on your system.

The upload location is configurable, and will require you to set it
up to serve assets as defined in config -> local -> uploads

Not having the static server won't break anything; you'll still be able
to test image uploads by looking in the uploads folder but you'll have no
way of linking to them and viewing them.

If you already know how to get nginx up and running, here's the config I'm using:

  /usr/local/etc/nginx/nginx.conf

    server {
        listen 80;
        server_name uploads.ntpigeon.local;

        location / {
            root /Users/caseywebb/Dev/northtexaspigeon/uploads;
        }
    }

 /private/etc/hosts

   127.0.0.1 uploads.ntpigeon.local

We're using the mkdirp module (https://www.npmjs.org/package/mkdirp) so you
don't have to worry about provisioning the folder, it just needs to exist and be
able to serve assets.
###

gm            = require 'gm'
Writable      = require('stream').Writable
fs            = require 'fs'
mkdirp        = require 'mkdirp'
slug          = require 'slug'
uploadsFolder = sails.config.uploads.folder

module.exports = 

  forArticles: (articleTitle) ->

    receiver  = new Writable { objectMode: true }
    receiver._write = (img, enc, cb) ->

      articleFolder = "#{uploadsFolder}/articles/#{slug(articleTitle)}"
      mkdirp articleFolder, (err) ->
        return cb(err) if err?

        if (img.filename.indexOf('headlineImg') == 0)

          img.fd =
            thumb:   "#{sails.config.uploads.url}/articles/#{slug(articleTitle)}/thumb-#{img.filename}"
            feature: "#{sails.config.uploads.url}/articles/#{slug(articleTitle)}/feature-#{img.filename}"
            full:    "#{sails.config.uploads.url}/articles/#{slug(articleTitle)}/#{img.filename}"

          thumbStream     = fs.createWriteStream("#{articleFolder}/thumb-#{img.filename}")
          featuredStream  = fs.createWriteStream("#{articleFolder}/feature-#{img.filename}")
          fullSizeStream  = fs.createWriteStream("#{articleFolder}/#{img.filename}")

          gm(img).resize(150, 100).quality(40).stream().pipe(thumbStream)
          gm(img).resize(400, 250).quality(60).stream().pipe(featuredStream)
          gm(img).resize(600, 400).quality(70).stream().pipe(fullSizeStream)

        else

          img.fd = "#{sails.config.uploads.url}/articles/#{slug(articleTitle)}/#{img.filename}"
          
          outStream = fs.createWriteStream("#{articleFolder}/#{img.filename}")
          
          gm(img).resize(400, 400).quality(60).stream().pipe(outStream)
        
        cb()

    return receiver


  forPictures: (pictureTitle) ->

    receiver = new Writable { objectMode: true }
    receiver._write = (img, enc, cb) ->

      pictureFolder = "#{uploadsFolder}/pictures/#{slug(pictureTitle)}"
      mkdirp pictureFolder, (err) ->
        return cb(err) if err?

        img.fd =
          feature: "#{sails.config.uploads.url}/pictures/#{slug(pictureTitle)}/feature-#{img.filename}"
          full:    "#{sails.config.uploads.url}/pictures/#{slug(pictureTitle)}/#{img.filename}"

        featuredStream  = fs.createWriteStream("#{pictureFolder}/feature-#{img.filename}")
        fullSizeStream  = fs.createWriteStream("#{pictureFolder}/#{img.filename}")

        gm(img).resize(220, 220).quality(50).stream().pipe(featuredStream)
        gm(img).resize(600, 400).quality(70).stream().pipe(fullSizeStream)


        cb()

    return receiver


  forAds: (adName) ->

    receiver = new Writable { objectMode: true }
    receiver._write = (img, enc, cb) ->

      adFolder = "#{uploadsFolder}/ads/#{slug(adName)}"
      mkdirp adFolder, (err) ->
        return cb(err) if err?

        img.fd = "#{sails.config.uploads.url}/ads/#{slug(adName)}/#{img.filename}"
        stream = fs.createWriteStream("#{adFolder}/#{img.filename}")

        switch img.filename.split('.')[0]

          when 'horizontal' then gm(img).resize(600, 150).quality(50).stream().pipe(stream)
          when 'mobile' then gm(img).resize(300, 150).quality(50).stream().pipe(stream)
          when 'vertical' then gm(img).resize(150, 600).quality(50).stream().pipe(stream)

        cb()

    return receiver
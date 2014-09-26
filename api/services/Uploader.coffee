###
This module contains the receivers for uploading and resizing images.
You will need graphicsmagick installed on your system.

The upload location isn't configurable, and will require you to set it
up to serve assets at the url provided in local.coffee -> uploads -> url.
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

If you know nothing about nginx, check the 'Getting Up and Running' wiki
on GitHub.

We're using the mkdirp module (https://www.npmjs.org/package/mkdirp) so you
don't have to worry about provisioning the folder, it just needs to exist and be
able to serve assets.
###

gm            = require 'gm'
Writable      = require('stream').Writable
fs            = require 'fs'
mkdirp        = require 'mkdirp'
slug          = require 'slug'
uploadsFolder = "#{__dirname}/../../uploads"

module.exports = 

  forArticles: (articleTitle) ->

    receiver  = new Writable { objectMode: true}
    receiver._write = (img, enc, cb) ->

      articleFolder = "#{uploadsFolder}/articles/#{slug(articleTitle)}"
      mkdirp articleFolder, (err) ->
        return cb(err) if err

        if (img.filename.indexOf('headlineImg') == 0)
          outThumbLocation    = "#{articleFolder}/thumb-#{img.filename}"
          outFeatureLocation  = "#{articleFolder}/feature-#{img.filename}"
          outFullLocation     = "#{articleFolder}/#{img.filename}"

          img.fd =
            thumb:   "#{sails.config.uploads.url}/articles/#{slug(articleTitle)}/thumb-#{img.filename}"
            feature: "#{sails.config.uploads.url}/articles/#{slug(articleTitle)}/feature-#{img.filename}"
            full:    "#{sails.config.uploads.url}/articles/#{slug(articleTitle)}/#{img.filename}"

          thumbStream     = fs.createWriteStream(outThumbLocation)
          featuredStream  = fs.createWriteStream(outFeatureLocation)
          fullSizeStream  = fs.createWriteStream(outFullLocation)

          gm(img).resize(150, 100).quality(40).stream().pipe(thumbStream)
          gm(img).resize(400, 250).quality(60).stream().pipe(featuredStream)
          gm(img).resize(600, 400).quality(80).stream().pipe(fullSizeStream)

        else
          outLocation = "#{articleFolder}/#{img.filename}"

          img.fd = "#{sails.config.uploads.url}/articles/#{slug(articleTitle)}/#{img.filename}"
          
          outStream = fs.createWriteStream(outLocation)
          
          gm(img).resize(400, 400).quality(60).stream().pipe(outStream)
        
        cb()

    return receiver
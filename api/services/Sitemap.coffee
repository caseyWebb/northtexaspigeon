sm    = require 'sitemap'
_     = require 'lodash'
http  = require 'http'

module.exports = Sitemap =

  generateXML: (cb) ->

    async.parallel [

      (resolve) ->
        Article.native (err, collection) ->
          collection.distinct 'slug', null, null, (err, slugs) ->
            resolve err, _.map(slugs, (slug) -> return url: "/article/#{slug}")  

      (resolve) ->
        Picture.native (err, collection) ->
          collection.distinct 'slug', null, null, (err, slugs) ->
            resolve err, _.map(slugs, (slug) -> return url: "/picture/#{slug}")  

      (resolve) ->
        Video.native (err, collection) ->
          collection.distinct 'slug', null, null, (err, slugs) ->
            resolve err, _.map(slugs, (slug) -> return url: "/video/#{slug}") 

    ], (err, results) ->


      allUrls = results[0].concat(results[1]).concat(results[2])
      allUrls.push
        url: '/'
        changefreq: 'daily'
        priority: 0.3

      sitemap = sm.createSitemap
        hostname: 'http://northtexaspigeon.com'
        cacheTime: 600000
        urls: allUrls

      sitemap.toXML (xmlSitemap) ->
        cb(xmlSitemap)

  submit: ->
    http.get "www.google.com/webmasters/tools/ping?sitemap=#{encodeURIComponent('http://northtexaspigon.com/sitemap.xml')}", (res) ->
      sails.log.info "#{Date().toString()}: sitemap submitted to Google"

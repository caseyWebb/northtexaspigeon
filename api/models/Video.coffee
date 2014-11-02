 # Video.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

slug    = require 'slug'
marked  = require 'marked'

module.exports =

  attributes:

    youtubeURL:
      type: 'string'
      required: true
      unique: true

    youtubeID:
      type: 'string'
      required: true
      unique: true

    title:
      type: 'string'
      required: true
      unique: true
      maxLength: 100

    slug:
      type: 'string'
      required: true
      unique: true

    tags:
      type: 'array'
      array: true

    markdown:
      type: 'text'
      required: true

    html:
      type: 'text'
      required: true

    viewCount:
      type: 'integer'
      defaultsTo: 0

    commentCount:
      type: 'integer'
      defaultsTo: 0

    ###
    We embed the author in the document so we can use one db query.
    When writers change their information, we search for videos
    with the author's id to update the embedded info.
    ###
    poster:
      type: 'JSON'
      required: true

  findOneByIdentifier: (identifier, cb) ->
    Video.findOne
      where:
        or: [
          { id: identifier }
          ,
          { slug: identifier }
        ]
    .exec cb

  logHit: (video) ->
    video.viewCount++
    video.save()

  latest: (cb) ->
    Video.find
      sort: 'createdAt DESC'
      limit: 4
    .exec (err, videos) ->
      videos = _.sortBy(videos, 'viewCount')
      cb(err, videos)

  beforeValidation: (video, cb) ->

    # slug-ify title for URL
    video.slug = slug(video.title).replace(/"/g, '')

    # hashtag content
    Formatter.hashtag video.markdown, (taggedMD, tags) ->
      video.tags = _.map tags, (tag) ->
                        tag.substring(1).toLowerCase()              

      # markdown
      renderer = new marked.Renderer()
      renderer.heading = (text) ->
        return text

      video.html = marked(taggedMD, renderer: renderer)

      cb()

  afterCreate: (article, cb) ->
    Sitemap.submit()
    cb()
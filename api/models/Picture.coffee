 # Picture.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

slug    = require 'slug'

module.exports =
  
  attributes:
    
    title:
      type: 'string'
      required: true
      unique: true
      maxLength: 100

    ###
    holds two values,
      full: <url to fullsize img>
      featured: <url to features size img>
    ###
    image: 
      type: 'JSON'
      required: true

    slug:
      type: 'string'
      unique: true
      required: true

    ###
    not displayed anywhere, but used for tagging
    ###
    markdown:
      type: 'string'

    tags:
      type: 'array'
      array: true

    commentCount: 
      type: 'integer'
      defaultsTo: 0

    viewCount:
      type: 'integer'
      defaultsTo: 0

    ###
    We embed the author in the document so we can use one db query.
    When writers change their information, we search for pics
    with the author's id to update the embedded info.
    ###
    curator:
      type: 'JSON'
      required: true

  findOneByIdentifier: (identifier, cb) ->
    Picture.findOne
      where:
        or: [
          { id: identifier }
          ,
          { slug: identifier }
        ]
    .exec cb

  logHit: (picture) ->
    picture.viewCount++
    picture.save()

  latest: (cb) ->
    Picture.find
      sort: createdAt: 'DESC'
      limit: 4
    .exec cb

  beforeValidation: (picture, cb) ->

    # slug-ify title for URL
    picture.slug = slug(picture.title).replace(/"/g, '')

    # hashtag pic
    Formatter.hashtag picture.markdown, (taggedMD, tags) ->
      picture.tags = _.map tags, (tag) ->
                        tag.substring(1).toLowerCase()              

      cb()

  afterCreate: (article, cb) ->
    Sitemap.submit()
    cb()

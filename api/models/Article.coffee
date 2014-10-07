 # Article.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

slug    = require 'slug'
marked  = require 'marked'

module.exports =

  attributes: 

    title:
      type: 'string'
      required: true
      unique: true
      maxLength: 100

    slug:
      type: 'string'
      unique: true
      required: true

    description:
      type: 'string'
      maxLength: 240
      required: true

    headlineImg:    # holds three values: thumb, feature, full
      type: 'JSON'

    category:
      type: 'string'
      required: true

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
    When writers change their information, we search for articles
    with the author's id to update the embedded info.
    ###
    author:
      type: 'JSON'
      required: true

  findOneByIdentifier: (identifier, cb) ->
    Article.findOne
      where:
        or: [
          { id: identifier }
          ,
          { slug: identifier }
        ]
    .exec cb

  logHit: (article) ->
    article.viewCount++
    article.save()

  homepageContent: (cb) ->
    
    async.parallel [

      (resolve) ->
        Article.find
          where: category: 'news'
          sort: createdAt: 'DESC'
          limit: 8
        .exec (err, articles) ->
          return resolve(err) if err?
        
          articles = _.sortBy(articles, ['viewCount'])
          trending = articles.splice(0, 4)
      
          articles = _.sortBy(articles, ['createdAt'])
          latest = articles
            
          resolve null,
            trending: trending
            latest: latest

      (resolve) ->
        Article.find
          where: category: 'columns'
          sort: createdAt: 'DESC'
          limit: 8
        .exec (err, articles) ->
          return resolve(err) if err?
          resolve null, _.sortBy(articles, ['viewCount'])

      ], (err, results) ->
        return cb(err) if err?

        cb null,
          news: results[0]
          columns: results[1]

  beforeValidation: (article, cb) ->

    # slug-ify title for URL
    article.slug = slug(article.title).replace(/"/g, '')

    # hashtag article
    Formatter.hashtag article.markdown, (taggedMD, tags) ->
      article.tags = _.map tags, (tag) ->
                        tag.substring(1).toLowerCase()              

      # markdown
      renderer = new marked.Renderer()
      renderer.heading = (text) ->
        return text

      article.html = marked(taggedMD, renderer: renderer)

      cb()

  afterCreate: (article, cb) ->
    Sitemap.submit()
    cb()
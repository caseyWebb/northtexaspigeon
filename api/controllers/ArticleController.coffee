 # ArticleController
 #
 # @description :: Server-side logic for managing articles
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 

  find: (req, res) ->
    Article.find
      where:
        title:
          contains:
            req.param('searchText') || ''
      sort: 'createdAt DESC'
      skip: 15 * req.param('page') || 0
      limit: 15
    .exec (err, articles) ->
      return res.serverError(err) if err
      res.ok({ articles: articles })

  findByCategory: (req, res) ->
    Article.findByCategory(req.param('category'))
    .skip(15 * req.param('page') || 0)
    .sort('createdAt DESC')
    .limit(15)
    .exec (err, articles) ->
      return res.serverError(err) if err
      res.ok({ articles: articles }, view: 'article/find')

  findOne: (req, res) ->
    Article.findOneByIdentifier req.param('id'), (err, article) ->
      return res.serverError(err) if err
      res.ok(article)
      Article.logHit(article)
      
  create: (req, res) ->
    
    # upload images
    req.file('images').upload Uploader.forArticles(req.param('title')), (err, uploadedFiles) ->

      # sub tmp srcs for new URLs
      Formatter.subImgSrcs req.param('markdown'), uploadedFiles, (mdWithImgUrls) ->

        # find the headline image
        for img in uploadedFiles
          if img.filename.indexOf('headlineImg') == 0
            headlineImgFds = img.fd

        # fetch current user
        User.findOne(req.session.user.id).exec (err, currentUser) ->
          return res.serverError(err) if err
        
          # create the article
          Article.create
            title:              req.param('title')
            description:        req.param('description') || ''
            author:             currentUser
            headlineImg:        headlineImgFds
            category:           req.param('category')
            markdown:           mdWithImgUrls
          .exec (err, article) ->
            return res.serverError(err) if err
            res.json(article)

  update: (req, res) ->

    # upload image
    req.file('images').upload Uploader.forArticles(req.param('title')), (err, uploadedFiles) ->

      # sub tmp srcs for new URLs
      Formatter.subImgSrcs req.param('markdown'), uploadedFiles, (mdWithImgUrls) ->

        # find the headline image
        for img in uploadedFiles
          if img.filename.indexOf('headlineImg') == 0
            headlineImgFds = img.fd

        Article.update req.param('id'),
          title:        req.param('title')
          description:  req.param('description') || ''
          headlineImg:  headlineImgFds || req.param('headlineImg')
          category:     req.param('category')
          markdown:     mdWithImgUrls
        .exec (err, articles) ->
          return res.serverError(err) if err
          res.json(articles[0])

  comment: (req, res) ->
    Article.findOneByIdentifier req.param('id'), (err, article) ->
      article.commentCount++
      article.save (err, article) ->
        return res.serverError(err) if err
        res.ok()
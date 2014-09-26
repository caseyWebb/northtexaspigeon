 # ArticleController
 #
 # @description :: Server-side logic for managing articles
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 

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

    # upload images
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

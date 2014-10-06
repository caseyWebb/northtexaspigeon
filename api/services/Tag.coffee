module.exports =

  find: (cb) ->
    async.parallel [

      (cb) ->
        Article.native (err, collection) ->
          collection.distinct 'tags', null, null, cb
      (cb) ->
        Video.native (err, collection) ->
          collection.distinct 'tags', null, null, cb
      (cb) ->
        Picture.native (err, collection) ->
          collection.distinct 'tags', null, null, cb
    
    ], (err, results) ->
      return cb(err) if err?
      cb(null, results[0].concat(results[1]).concat(results[2]))

  findContentFor: (tag, cb) ->

    async.parallel [

      # news
      (cb) ->
        Article.find
          where:
            tags: contains: tag
            category: 'news'
          sort: createdAt: 'DESC'
        .exec (err, news) ->
          for article in news
            delete article.html
            delete article.markdown

          cb(err, news)

      # columns
      (cb) ->
        Article.find
          where:
            tags: contains: tag
            category: 'column'
          sort: createdAt: 'DESC'
        .exec (err, columns) ->
          for article in columns
            delete article.html
            delete article.markdown

          cb(err, columns)

      # pictures
      (cb) ->
        Picture.find
          where: tags: contains: tag
          sort: createdAt: 'DESC'
        .exec cb

      # videos
      (cb) ->
        Video.find
          where: tags: contains: tag
          sort: createdAt: 'DESC'
        .exec cb
    
    ], (err, resultsArr) ->
      return cb(err) if err? 

      cb null,
        news: resultsArr[0]
        columns: resultsArr[1]
        pictures: resultsArr[2]
        videos: resultsArr[3]
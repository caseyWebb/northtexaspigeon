 # HomepageController
 #
 # @description :: Server-side logic for managing homepages
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =

  homepage: (req, res) ->

    async.parallel [

      (resolve) ->
        Article.homepageContent(resolve)

      (resolve) ->
        Picture.latest(resolve)

      (resolve) ->
        Video.latest(resolve)

      (resolve) ->
        Tag.find(resolve)

    ], (err, results) ->
      return res.serverError(err) if err?

      content = results[0]
      content.pictures = results[1]
      content.videos = results[2]
      content.tags = _.sample(results[3], 30)

      res.ok(content, 'homepage')
        


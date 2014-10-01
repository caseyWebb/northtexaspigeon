 # VideoController
 #
 # @description :: Server-side logic for managing videos
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =

  find: (req, res) ->
    Video.find
      where:
        title:
          contains:
            req.param('searchText') || ''
      sort: 'createdAt DESC'
      skip: 15 * req.param('page') || 0
      limit: 15
    .exec (err, videos) ->
      return res.serverError(err) if err
      res.ok({ videos: videos })

  findOne: (req, res) ->
    Video.findOneByIdentifier req.param('id'), (err, video) ->
      return res.serverError(err) if err
      res.ok(video)
      Video.logHit(video)

  create: (req, res) ->
  
      # fetch current video
      User.findOne(req.session.user.id).exec (err, currentUser) ->
        return res.serverError(err) if err
      
        # create the video
        Video.create
          title:              req.param('title')
          youtubeURL:         req.param('youtubeURL')
          youtubeID:          req.param('youtubeID')
          poster:             currentUser
          markdown:           req.param('markdown') || ''
        .exec (err, video) ->
          return res.serverError(err) if err
          res.json(video)

  comment: (req, res) ->
    Video.findOneByIdentifier req.param('id'), (err, video) ->
      video.commentCount++
      video.save (err, vido) ->
        return res.serverError(err) if err
        res.ok()
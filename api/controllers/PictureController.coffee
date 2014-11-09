 # PictureController
 #
 # @description :: Server-side logic for managing Pictures
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports = 
  
  find: (req, res) ->
    Picture.find
      where:
        title:
          contains:
            req.param('searchText') || ''
      sort: 'createdAt DESC'
      skip: 15 * req.param('page') || 0
      limit: 15
    .exec (err, pictures) ->
      return res.serverError(err) if err?
      res.ok({ pictures: pictures })

  findOne: (req, res) ->
    Picture.findOneByIdentifier req.param('id'), (err, picture) ->
      return res.serverError(err) if err?
      res.ok(picture)
      Picture.logHit(picture)

  create: (req, res) ->

    # upload image
    req.file('images').upload Uploader.forPictures(req.param('title')), (err, uploadedFile) ->

      # fetch current user
      User.findOne(req.session.user.id).exec (err, currentUser) ->
      
        return res.serverError(err) if err?

        # create picture record
        Picture.create
          title: req.param('title')
          image: uploadedFile[0].fd
          curator: currentUser
          markdown: req.param('markdown')       
        .exec (err, picture) ->
          return res.serverError(err) if err?
          res.json(picture)

  update: (req, res) ->
    
    # upload image
    req.file('images').upload Uploader.forPictures(req.param('title')), (err, uploadedFile) ->
      return res.serverError(err) if err?

      # create picture record
      Picture.update req.param('id'),
        title: req.param('title')
        image: uploadedFile[0]?.fd || req.param('image')
        markdown: req.param('markdown')       
      .exec (err, pictures) ->
        return res.serverError(err) if err?
        res.json(pictures[0])

  comment: (req, res) ->
    Picture.findOneByIdentifier req.param('id'), (err, picture) ->
      picture.commentCount++
      picture.save (err, pic) ->
        return res.serverError(err) if err?
        res.ok()

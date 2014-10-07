 # AdvertisementController
 #
 # @description :: Server-side logic for managing advertisements
 # @help        :: See http://links.sailsjs.org/docs/controllers

module.exports =

  find: (req, res) ->
    Advertisement.find
      where: expiresOn:
        '>': new Date()
    .exec (err, ads) ->
      return res.serverError(err) if err
      res.json(ads)

  create: (req, res) ->
    
    # upload images
    req.file('images').upload Uploader.forAds(req.param('name')), (err, uploadedFiles) ->
      
      images = {}

      for file in uploadedFiles
        images[file.filename.split('.')[0]] = file.fd

      # create the ad
      Advertisement.create
        name:               req.param('name')
        mobileLink:         req.param('mobileLink')
        desktopLink:        req.param('desktopLink')
        images:             images
        runLength:          req.param('runLength')
      .exec (err, ad) ->
        return res.serverError(err) if err
        res.json(ad)

  update: (req, res) ->
    
    # upload images
    req.file('images').upload Uploader.forAds(req.param('name')), (err, uploadedFiles) ->
      
      images = {}

      for file in uploadedFiles
        images[file.filename.split('.')[0]] = file.fd

      updatedImages = _.extend(JSON.parse(req.param('images')), images)

      # create the ad
      Advertisement.update req.param('id'),
        name:               req.param('name')
        mobileLink:         req.param('mobileLink')
        desktopLink:        req.param('desktopLink')
        images:             updatedImages
        runLength:          req.param('runLength')
      .exec (err, ad) ->
        return res.serverError(err) if err
        res.json(ad)
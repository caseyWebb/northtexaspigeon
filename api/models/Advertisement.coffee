 # Advertisement.coffee
 #
 # @description :: TODO: You might write a short summary of how this model works and what it represents here.
 # @docs        :: http://sailsjs.org/#!documentation/models

module.exports =

  attributes:

    name:
      type: 'string'
      required: true

    mobileLink:
      type: 'string'
      required: true

    desktopLink:
      type: 'string'
      required: true

    images:           # store 3 versions,
      type: 'JSON'    # horizontal, vertical, and mobile
      required: true

    runLength:
      type: 'integer'
      required: true

    expiresOn:
      type: 'datetime'
      # required: true, this is required, but it is generated
      # in a lifecycle callback

  beforeCreate: (ad, next) ->
    expiresOnDate = new Date()
    expiresOnDate.setDate(expiresOnDate.getDate() + ad.runLength)
    ad.expiresOn = expiresOnDate

    next()

  afterUpdate: (ad, next) ->
    expiresOnDate = new Date(ad.createdAt)
    expiresOnDate.setDate(expiresOnDate.getDate() + ad.runLength)

    if ad.expiresOn.toString() != expiresOnDate.toString()
      Advertisement.update ad.id,
        expiresOn: expiresOnDate
      .exec (err, ad) ->
        next(err)
    else
      next()
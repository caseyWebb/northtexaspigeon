app

.controller 'adCtrl',
  ['$scope', '$http',
  (  s,        http ) ->

    ### vars ###

    s.ads = []
    s.isEditing = false

    ### functions ###

    s.getAds = () ->

      http.get('/advertisement')

      .success (ads) ->
        s.ads = ads
      
      .error (err) ->
        alert(err)


    s.selectAd = (adID) ->
      if !adID
        return s.ad = {}

      else 
        http.get("/advertisement/#{adID}")

          .success (ad) ->
            s.ad = ad
           
          .error (err) ->
            alert(err)

    s.toggleEditor = (explicitVal) ->
      s.isEditing = explicitVal? ? explicitVal : !s.isEditing

    #### init ###

    s.getAds()
]

####################### SHOW ############################

.controller 'adShowCtrl',
  ['$scope', '$stateParams', '$http', '$state', 'toaster',
  (  s,        stateParams,    http,    state,   toaster ) ->

    s.selectAd(stateParams.adID)

    s.$on '$stateChangeStart', ->
      s.selectAd()

    s.delete = ->
      if window.confirm("Are you sure you want to delete this?")
        http.delete("/advertisement/#{s.ad.id}")
          .success ->
            toaster.pop('success', 'Ad Deleted!')
            s.$parent.ads = _.reject s.ads, (ad) -> return s.ad.id == ad.id
            state.go('ad')
          .error (err) ->
            toaster.pop('error', err)
]

##################### NEW / EDIT ########################

.controller 'adEditCtrl',
  ['$scope', '$http', '$upload', '$state', 'toaster', '$stateParams',
  (  s,        http,    upload,    state,   toaster,    stateParams ) ->

    s.toggleEditor(true)

    if (stateParams.adID)
      s.selectAd(stateParams.adID)
    else
      s.selectAd()

    s.$on '$stateChangeStart', ->
      s.selectAd()
      s.toggleEditor()

    s.images = {}
    s.setImage = (files, imgName) ->

      img = files[0]

      reader = new FileReader()

      reader.onload = (e) =>
        s.images[imgName] =
          file: img
          name: "#{imgName}.#{img.name.split('.').pop()}"
          dataUrl: reader.result
        s.$apply()
      
      reader.readAsDataURL(img)

    s.publish = () ->

      s.publishing = true
      updating = s.ad.id?

      imgFiles = _.pluck(s.images, 'file')
      imgNames = _.pluck(s.images, 'name')

      upload.upload
        url: "/advertisement/#{if updating then s.ad.id else ''}"
        method: if updating then 'PUT' else 'POST'
        data:
          name: s.ad.name
          mobileLink: s.ad.mobileLink
          desktopLink: s.ad.desktopLink
          images: s.ad.images
          runLength: s.ad.runLength
        file: imgFiles
        fileName: imgNames
        fileFormDataName: 'images'

      .success (ad) ->
        if updating
          toaster.pop('success', 'Ad Updated!')
          s.$parent.ads = _.reject s.ads, (_ad) -> return _ad.id == ad.id
        else
          toaster.pop('success', 'Ad Uploaded!')
        
        s.$parent.ads.push(ad)
        state.go('ad')

      .error (err) ->
        toaster.pop('error', err)
]
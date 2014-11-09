app

.controller 'pictureCtrl',
  ['$scope', '$http',
  (  s,        http ) ->

    ### vars ###

    s.pictures = []
    s.isEditing = false

    ### functions ###

    s.getPictures = _.throttle (replace) ->
      @currentPage ?= 0

      if replace
        @currentPage = 0
        @endReached = false

      return if @endReached

      http 
        url: '/picture'
        params:
          page: @currentPage++
          searchText: s.searchText

      .success (res) =>
        if res.pictures.length < 15
          @endReached = true

        if replace
          s.pictures = res.pictures
        else
          s.pictures = s.pictures.concat(res.pictures)
      
      .error (err) ->
        alert(err)

    , 300


    s.selectPicture = (pictureID) ->
      if !pictureID
        return s.picture = {}

      else 
        http.get("/picture/#{pictureID}")

          .success (picture) ->
            s.picture = picture
           
          .error (err) ->
            alert(err)

    s.toggleEditor = (explicitVal) ->
      s.isEditing = explicitVal? ? explicitVal : !s.isEditing

    #### init ###

    s.getPictures()
]

####################### SHOW ############################

.controller 'pictureShowCtrl',
  ['$scope', '$stateParams', '$http', '$state', 'toaster',
  (  s,        stateParams,    http,    state,   toaster ) ->

    s.selectPicture(stateParams.pictureID)

    s.$on '$stateChangeStart', ->
      s.selectPicture()

    s.delete = ->
      if window.confirm("Are you sure you want to delete this?")
        http.delete("/picture/#{s.picture.id}")
          .success ->
            toaster.pop('success', 'Picture Deleted!')
            s.$parent.pictures = _.reject s.pictures, (picture) -> return s.picture.id == picture.id
            state.go('picture')
          .error (err) ->
            toaster.pop('error', err)
]

##################### NEW / EDIT ########################

.controller 'pictureEditCtrl',
  ['$scope', '$http', '$upload', '$state', 'toaster', '$stateParams',
  (  s,        http,    upload,    state,   toaster,    stateParams ) ->

    s.toggleEditor(true)

    if (stateParams.pictureID)
      s.selectPicture(stateParams.pictureID)
    else
      s.selectPicture()

    s.$on '$stateChangeStart', ->
      s.selectPicture()
      s.toggleEditor()

    s.setImage = (files) ->

      img = files[0]

      reader = new FileReader()

      reader.onload = (e) =>
        s.picture.image =
          file: img
          dataUrl: reader.result
        s.$apply()
      
      reader.readAsDataURL(img)

    s.publish = () ->

      s.publishing = true
      updating = s.picture.id?

      upload.upload
        url: "/picture/#{if updating then s.picture.id else ''}"
        method: if updating then 'PUT' else 'POST'
        data:
          title: s.picture.title
          image: s.picture.image
          markdown: s.picture.markdown
        file: s.picture.image.file
        fileFormDataName: 'images'

      .success (picture) ->
        if updating
          toaster.pop('success', 'Picture Updated!')
          s.$parent.pictures = _.reject s.pictures, (_picture) -> return _picture.id == picture.id
        else
          toaster.pop('success', 'Picture Uploaded!')
        
        s.$parent.pictures.push(picture)
        state.go('picture')

      .error (err) ->
        toaster.pop('error', err)
]
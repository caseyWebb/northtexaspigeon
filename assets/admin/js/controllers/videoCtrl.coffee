app

.controller 'videoCtrl',
  ['$scope', '$http',
  (  s,        http ) ->

    ### vars ###

    s.videos = []
    s.isEditing = false

    ### functions ###

    s.getVideos = _.throttle (replace) ->
      @currentPage ?= 0

      if replace
        @currentPage = 0
        @endReached = false

      return if @endReached

      http 
        url: '/video'
        params:
          page: @currentPage++
          searchText: s.searchText

      .success (res) =>
        if res.videos.length < 15
          @endReached = true

        if replace
          s.videos = res.videos
        else
          s.videos = s.videos.concat(res.videos)
      
      .error (err) ->
        alert(err)

    , 300


    s.selectVideo = (videoID) ->
      if !videoID
        return s.video = {}

      else 
        http.get("/video/#{videoID}")

          .success (video) ->
            s.video = video
           
          .error (err) ->
            alert(err)

    s.toggleEditor = (explicitVal) ->
      s.isEditing = explicitVal? ? explicitVal : !s.isEditing

    #### init ###

    s.getVideos()
]

####################### SHOW ############################

.controller 'videoShowCtrl',
  ['$scope', '$stateParams', '$http', '$state', 'toaster',
  (  s,        stateParams,    http,    state,   toaster ) ->

    s.selectVideo(stateParams.videoID)

    s.$on '$stateChangeStart', ->
      s.selectVideo()

    s.delete = ->
      if window.confirm("Are you sure you want to delete this?")
        http.delete("/video/#{s.video.id}")
          .success ->
            toaster.pop('success', 'Video Deleted!')
            s.$parent.videos = _.reject s.videos, (video) -> return s.video.id == video.id
            state.go('video')
          .error (err) ->
            toaster.pop('error', err)
]

##################### NEW / EDIT ########################

.controller 'videoEditCtrl',
  ['$scope', '$http', '$state', 'toaster', '$stateParams',
  (  s,        http,    state,   toaster,    stateParams ) ->

    s.toggleEditor(true)

    if (stateParams.videoID)
      s.selectVideo(stateParams.videoID)
    else
      s.selectVideo()

    s.$on '$stateChangeStart', ->
      s.selectVideo()
      s.toggleEditor()

    s.getYoutubeID = (url) ->
      return if !url?

      id = url.split('v=')[1]
      ampersandPosition = id.indexOf('&')
      if(ampersandPosition != -1)
        id = id.substring(0, ampersandPosition)

      return id

    s.publish = () ->

      s.publishing = true
      updating = s.video.id?

      http
        url: "/video/#{if updating then s.video.id else ''}"
        method: if updating then 'PUT' else 'POST'
        data:
          title: s.video.title
          youtubeURL: s.video.url
          youtubeID: s.getYoutubeID(s.video.url)
          markdown: s.video.markdown

      .success (video) ->
        if updating
          toaster.pop('success', 'Video Updated!')
          s.$parent.videos = _.reject s.videos, (_video) -> return _video.id == video.id
        else
          toaster.pop('success', 'Video Uploaded!')
        
        s.$parent.videos.push(video)
        state.go('video')

      .error (err) ->
        toaster.pop('error', err)
]
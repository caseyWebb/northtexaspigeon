app

.controller 'articleCtrl',
  ['$scope', '$http',
  (  s,        http ) ->

    ### vars ###

    s.articles = []
    s.isEditing = false

    ### functions ###

    s.getArticles = _.throttle (replace) ->
      @currentPage ?= 0

      if replace
        @currentPage = 0
        @endReached = false

      return if @endReached

      http 
        url: '/article'
        params:
          page: @currentPage++
          searchText: s.searchText

      .success (res) =>
        if res.articles.length < 15
          @endReached = true

        if replace
          s.articles = res.articles
        else
          s.articles = s.articles.concat(res.articles)
      
      .error (err) ->
        alert(err)

    , 300


    s.selectArticle = (articleID) ->
      if !articleID
        return s.article = {}

      else 
        http.get("/article/#{articleID}")

          .success (article) ->
            s.article = article
           
          .error (err) ->
            alert(err)

    s.toggleEditor = (explicitVal) ->
      s.isEditing = explicitVal? ? explicitVal : !s.isEditing

    #### init ###

    s.getArticles()
]

####################### SHOW ############################

.controller 'articleShowCtrl',
  ['$scope', '$stateParams', '$http', '$state', 'toaster',
  (  s,        stateParams,    http,    state,   toaster ) ->

    s.selectArticle(stateParams.articleID)

    s.$on '$stateChangeStart', ->
      s.selectArticle()

    s.delete = ->
      if window.confirm("Are you sure you want to delete this?")
        http.delete("/article/#{s.article.id}")
          .success ->
            toaster.pop('success', 'Article Deleted!')
            s.$parent.articles = _.reject s.articles, (article) -> return s.article.id == article.id
            state.go('article')
          .error (err) ->
            toaster.pop('error', err)
]

##################### NEW / EDIT ########################

.controller 'articleEditCtrl',
  ['$scope', '$http', '$upload', '$state', 'toaster', '$stateParams',
  (  s,        http,    upload,    state,   toaster,    stateParams ) ->

    s.toggleEditor(true)

    if (stateParams.articleID)
      s.selectArticle(stateParams.articleID)
    else
      s.selectArticle()

    s.$on '$stateChangeStart', ->
      s.selectArticle()
      s.toggleEditor()

    s.setHeadlineImg = (files) ->

      img = files[0]

      reader = new FileReader()

      reader.onload = (e) =>
        s.article.headlineImg =
          file: img
          name: "headlineImg.#{img.name.split('.').pop()}"
          dataUrl: reader.result
        s.$apply()
      
      reader.readAsDataURL(img)

    s.insertPicture = (files) ->
      @counter ?= 0
      s.inlineImgs ?= {}

      img = files[0]
      caretPos = angular.element('#article-input')[0].selectionEnd

      reader = new FileReader()

      reader.onload = (e) =>
        s.inlineImgs[img.name] =
          file: img
          name: img.name
          dataUrl: reader.result

        markupToInsert = "\n![](#!#{img.name})\n"

        if s.article.markdown?
          s.article.markdown = s.article.markdown.slice(0, caretPos) + markupToInsert + s.article.markdown.slice(caretPos)
        else
          s.article.markdown = markupToInsert
            
        s.$apply()

      reader.readAsDataURL(img)

    s.publish = () ->

      s.publishing = true
      updating = s.article.id?

      allImgFiles = _.pluck(s.inlineImgs, 'file')
      allImgNames = _.pluck(s.inlineImgs, 'name')

      if (s.article.headlineImg?.file?)
        allImgFiles.unshift(s.article.headlineImg.file)
        allImgNames.unshift(s.article.headlineImg.name)

      upload.upload
        url: "/article/#{if updating then s.article.id else ''}"
        method: if updating then 'PUT' else 'POST'
        data:
          title: s.article.title
          description: s.article.description
          headlineImg: s.article.headlineImg
          category: s.article.category
          markdown: s.article.markdown
        file: allImgFiles
        fileName: allImgNames
        fileFormDataName: 'images'

      .success (article) ->
        if updating
          toaster.pop('success', 'Article Updated!')
          s.$parent.articles = _.reject s.articles, (_article) -> return _article.id == article.id
        else
          toaster.pop('success', 'Article Uploaded!')
        
        s.$parent.articles.push(article)
        state.go('article')

      .error (err) ->
        toaster.pop('error', err)
]
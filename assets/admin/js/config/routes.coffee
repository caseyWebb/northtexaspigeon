app.config([
  '$stateProvider', '$urlRouterProvider', '$locationProvider'
  ($stateProvider,   $urlRouterProvider,   $locationProvider) ->

    $locationProvider.html5Mode(true)
    $urlRouterProvider.otherwise('/admin')

    $stateProvider

    ############### LANDING ##################

      .state 'landing',
        url: '/admin'
        template: JST['/landing.html']()

    ################# USERS ##################

      .state 'user',
        url: '/admin/user'
        template: JST['/users/index.html']()
        controller: 'userCtrl'

      .state 'user.invite',
        url: '/invite'
        template: JST['/users/invite.html']()
        controller: 'userNewCtrl'

      .state 'user.show',
        url: '/:userID'
        template: JST['/users/show.html']()
        controller: 'userShowCtrl'

      .state 'profile',
        url: '/admin/profile'
        template: JST['/users/edit.html']()
        controller: 'profileCtrl'

    ################ ARTICLES ################

      .state 'article',
        url: '/admin/article'
        template: JST['/articles/index.html']()
        controller: 'articleCtrl'

      .state 'article.new',
        url: '/new'
        template: JST['/articles/edit.html']()
        controller: 'articleEditCtrl'

      .state 'article.show',
        url: '/:articleID'
        template: JST['/articles/show.html']()
        controller: 'articleShowCtrl'

      .state 'article.edit',
        url: '/:articleID/edit'
        template: JST['/articles/edit.html']()
        controller: 'articleEditCtrl'

    ################ PICTURES ################

      .state 'picture',
        url: '/admin/picture'
        template: JST['/pictures/index.html']()
        controller: 'pictureCtrl'

      .state 'picture.new',
        url: '/new'
        template: JST['/pictures/edit.html']()
        controller: 'pictureEditCtrl'

      .state 'picture.show',
        url: '/:pictureID'
        template: JST['/pictures/show.html']()
        controller: 'pictureShowCtrl'

      .state 'picture.edit',
        url: '/:pictureID/edit'
        template: JST['/pictures/edit.html']()
        controller: 'pictureEditCtrl'

    ################ VIDEOS ################

      .state 'video',
        url: '/admin/video'
        template: JST['/videos/index.html']()
        controller: 'videoCtrl'

      .state 'video.new',
        url: '/new'
        template: JST['/videos/edit.html']()
        controller: 'videoEditCtrl'

      .state 'video.show',
        url: '/:videoID'
        template: JST['/videos/show.html']()
        controller: 'videoShowCtrl'

      .state 'video.edit',
        url: '/:videoID/edit'
        template: JST['/videos/edit.html']()
        controller: 'videoEditCtrl'

    ################## ADS ##################

      .state 'ad',
        url: '/admin/ad'
        template: JST['/ads/index.html']()
        controller: 'adCtrl'

      .state 'ad.new',
        url: '/new'
        template: JST['/ads/edit.html']()
        controller: 'adEditCtrl'

      .state 'ad.show',
        url: '/:adID'
        template: JST['/ads/show.html']()
        controller: 'adShowCtrl'

      .state 'ad.edit',
        url: '/:adID/edit'
        template: JST['/ads/edit.html']()
        controller: 'adEditCtrl'

    ################## MAIL #################

      .state 'mail',
        url: '/admin/mail'
        template: JST['/mail/index.html']()
        controller: 'mailCtrl'

      .state 'mail.show',
        url: '/:threadID'
        template: JST['/mail/show.html']()
        controller: 'threadCtrl'

      
])
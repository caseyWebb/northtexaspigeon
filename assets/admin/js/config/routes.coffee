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

      
])
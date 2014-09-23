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

      .state 'users',
        url: '/admin/users'
        template: JST['/users/index.html']()
        controller: 'userCtrl'

      .state 'users.invite',
        url: '/invite'
        template: JST['/users/invite.html']()
        controller: ['$scope',
                    (  s ) ->
                      s.selectUser()
                    ]

      .state 'users.show',
        url: '/:userID'
        template: JST['/users/show.html']()
        controller: ['$scope', '$stateParams'
                    (  s,        stateParams ) ->
                      s.selectUser(stateParams.userID)
                    ]

      .state 'profile',
        url: '/admin/profile'
        template: JST['/users/edit.html']()
        controller: 'profileCtrl'
])
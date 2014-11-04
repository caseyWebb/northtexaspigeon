app.controller 'navCtrl',
  ['$scope', '$location', '$http', 'emailCounts',
  (  s,        location,    http,   emailCounts ) ->

    s.isActive = (route) ->
      location.path().indexOf('/admin' + route) == 0

    s.unreadEmailCounts = emailCounts
]
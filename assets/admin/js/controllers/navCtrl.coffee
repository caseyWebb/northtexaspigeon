app.controller 'navCtrl',
  ['$scope', '$location', '$http',
  (  s,        location,    http ) ->

    s.isActive = (route) ->
      location.path().indexOf('/admin' + route) == 0

    http.get '/email/unread', (unreadCount) ->
      s.unreadEmailCount = unreadCount
      alert unreadCount
]
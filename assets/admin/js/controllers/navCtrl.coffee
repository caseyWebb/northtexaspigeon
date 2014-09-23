app.controller 'navCtrl',
  ['$scope', '$location',
  (  s,        location ) ->

    s.isActive = (route) ->
      location.path().indexOf('/admin' + route) == 0
]
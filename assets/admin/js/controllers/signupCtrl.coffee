app.controller 'signupCtrl',
  ['$scope', '$http', '$location',
  (  s,        http,    location ) ->

    s.submit = (user) ->
      data =
        user: user
        token: location.search().token

      http.post('/user', data)
        .success (user) ->
          return # TODO: login user
        .error (err) ->
          alert(err)
]
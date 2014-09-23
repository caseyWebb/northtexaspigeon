app.controller 'profileCtrl',
  ['$scope', '$http', 'toaster',
  (  s,        http,   toaster ) ->

    ### functions ###

    s.save = (user) ->
      if !s.savingPass
        s.savingProfile = true

      return http.put("/user/#{s.user.id}", user)
        .success ->
          toaster.pop('success', "Saved successfully")

        .error (err) ->
          alert(err)
        .finally (err) ->
          s.savingProfile = false
          s.savingPass = false

    s.changePass = (pass) ->
      s.savingPass = true
      s.save
        password: pass


    #### init ###

    http.get('/user/current')

      .success (user) ->
        s.user = user

      .error (err) ->
        alert(err)

]
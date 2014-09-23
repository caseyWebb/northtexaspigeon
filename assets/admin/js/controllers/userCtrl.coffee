app.controller 'userCtrl',
  ['$scope', '$http', '$location', 'toaster'
  (  s,        http,    location,   toaster ) ->

    ### vars ###

    s.users = []
    s.selectedUser = {}


    ### functions ###

    s.selectUser = (userID) ->
      if !userID
        s.selectedUser = {}

      else if _.where(s.users, 'id': userID).length != 0
        s.selectedUser = _.find(s.users, 'id': userID)

      else
        http.get("/user/#{userID}")

          .success (user) ->
            s.selectedUser = user

          .error (err) ->
            alert(err)

    s.sendInvites = (emails) ->
      s.sendingInvites = true
      http.post('/user/invite', { emails: emails.replace(/\s/g, '').split(';') })
        .success ->
          toaster.pop('success', "Invites sent!")

        .error (err) ->
          alert(err)

        .finally ->
          s.sendingInvites = false

    s.updateUser = (user) ->
      http.put("/user/#{user.id}", user)
        .success ->
          toaster.pop('success', "Information updated")
        .error (err) ->
          alert(err)


    #### init ###

    http.get('/user')

      .success (users) ->
        s.users = users

      .error (err) ->
        alert(err)

]
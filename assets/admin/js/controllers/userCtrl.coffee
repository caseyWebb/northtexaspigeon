app

.controller 'userCtrl',
  ['$scope', '$http', '$location', 'toaster',
  (  s,        http,    location,   toaster ) ->

    ### vars ###

    s.users = []
    s.user = {}


    ### functions ###

    s.getUsers = ->

      http.get('/user')
      
        .success (users) ->
          s.users = users
      
        .error (err) ->
          alert(err)

    s.selectUser = (userID) ->
      if !userID
        s.user = {}

      else if userID == -1
        s.user = 'invite'

      else if _.where(s.users, 'id': userID).length != 0
        s.user = _.find(s.users, 'id': userID)

      else
        http.get("/user/#{userID}")

          .success (user) ->
            s.user = user

          .error (err) ->
            alert(err)

 
    #### init ###

    s.getUsers()
]

################# SHOW / EDIT #####################

.controller 'userShowCtrl',
  ['$scope', '$stateParams', '$http', 'toaster',
  (  s,        stateParams,    http,   toaster ) ->

    s.selectUser(stateParams.userID)

    s.$on '$stateChangeStart', ->
      s.selectUser()

    s.updateUser = (user) ->
      http.put("/user/#{user.id}", user)
        .success ->
          toaster.pop('success', "Information updated")
        .error (err) ->
          alert(err)
]

##################### INVITE ########################

.controller 'userNewCtrl',
  ['$scope', '$http', 'toaster',
  (  s,        http,   toaster ) ->

    s.selectUser(-1)

    s.$on '$stateChangeStart', ->
      s.selectUser()

    s.sendInvites = (emails) ->
      s.sendingInvites = true
      http.post('/user/invite', { emails: emails.replace(/\s/g, '').split(';') })
        .success ->
          toaster.pop('success', "Invites sent!")

        .error (err) ->
          alert(err)

        .finally ->
          s.sendingInvites = false
]
app

.controller 'userCtrl',
  ['$scope', '$http', '$location', 'toaster',
  (  s,        http,    location,   toaster ) ->

    ### vars ###

    s.users = []
    s.user = {}


    ### functions ###

    s.getUsers = _.throttle (replace) ->
      s.counter ?= 0
      pageSize = 15

      if replace
        s.counter = 0
        s.endReached = false

      return if s.endReached

      http 
        url: '/user'
        params:
          where:
            name:
              contains: s.searchText || ''
          skip: s.counter++ * pageSize
          limit: pageSize
          sort: 'name ASC'

      .success (users) ->
        if users.length < pageSize
          s.endReached = true

        if replace
          s.users = users
        else
          s.users = s.users.concat(users)
      
      .error (err) ->
        alert(err)

    , 300


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
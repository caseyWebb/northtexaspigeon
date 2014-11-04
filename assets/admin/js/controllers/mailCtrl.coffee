app

.controller 'mailCtrl',
  ['$scope', '$http',
  (  s,        http ) ->
    
    getThreads = ->
      http.get('/emailthread')
        .success (threads) ->
          s.threads = threads

    s.isActive = (route) ->
      location.path().indexOf('/admin' + route) == 0

    s.selectThread = (threadID) ->
      if !threadID
        return s.thread = {}

      else 
        http.get("/emailthread/#{threadID}")

          .success (thread) ->
            s.thread = thread
           
          .error (err) ->
            alert(err)

    getThreads()

]

.controller 'threadCtrl',
  ['$scope', '$stateParams', '$http', '$state', 'toaster',
  (  s,        stateParams,    http,    state,   toaster ) ->

    s.selectThread(stateParams.threadID)

    s.$on '$stateChangeStart', ->
      s.selectThread()

    s.delete = ->
      http.delete("/emailthread/#{s.thread.id}")
        .success ->
          toaster.pop('success', 'Conversation Deleted!')
          s.$parent.emailThreads = _.reject s.emailThreads, (thread) -> return s.thread.id == thread.id
          state.go('mail')
        .error (err) ->
          toaster.pop('error', err)
]
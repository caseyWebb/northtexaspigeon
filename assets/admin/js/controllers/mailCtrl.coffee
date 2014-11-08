app

.controller 'mailCtrl',
  ['$scope', '$http', 'emailCounts',
  (  s,        http,   emailCounts ) ->
    
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
            emailCounts[thread.mailbox] -= 1

            for thread in s.threads
              if thread.id == threadID
                thread.unread = false
           
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

    s.reply = ''

    s.sendReply = ->
      text = s.reply
      s.reply = ''

      s.thread.emails.push
        inbound: false
        html: """
          <ul class="loader">
            <li></li>
            <li></li>
            <li></li>
          </ul>
          """
        createdAt: new Date()
        
      http.post("/emailthread/#{s.thread.id}/reply", reply: text)
        .success ->
          s.thread.emails[s.thread.emails.length - 1].html = text


    s.delete = ->
      if window.confirm("Are you sure you want to delete this?")
        http.delete("/emailthread/#{s.thread.id}")
          .success ->
            toaster.pop('success', 'Conversation Deleted!')
            s.$parent.threads = _.reject s.threads, (thread) -> return s.thread.id == thread.id
            state.go('mail')
          .error (err) ->
            toaster.pop('error', err)
]



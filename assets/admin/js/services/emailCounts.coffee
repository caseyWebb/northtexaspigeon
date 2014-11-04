app.service 'emailCounts',
  ['$http',
  (  http  ) ->

    @kudos = 0
    @hatemail = 0
    @advertisers = 0

    http.get('/email/unread')
      .success (unreadCounts) =>
        @kudos = unreadCounts.kudos
        @hatemail = unreadCounts.hatemail
        @advertisers = unreadCounts.advertisers


    return this

]
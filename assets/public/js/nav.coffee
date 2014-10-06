do ->

  ###
  getPage(url)

  synchronously retrieves new page
  and stores it to the cache
  ###
  getPage = (url) ->
    self = @
    @pageCache ?= {}

    if !@pageCache[url]?
      $.ajax
        url: url
        data:
          noLayout:true, forceHTML:true
        async: false
        success: (htmlPartial) ->
          self.pageCache[url] = htmlPartial

    return @pageCache[url]

  ###
  setPage(url)

  sets the page's stage and updates the title
  ###
  setPage = (url) ->

    $('#stage').replaceWith(getPage(url))

    if $('.page-title').length > 0
      document.title = "North Texas Pigeon | " + $('.page-title').text()
    else
      document.title = "North Texas Pigeon"

  ###
  navigate(url)

  performs navigation and everything that goes along
  with it
  ###
  navigate = (url) ->
    setPage(url)
    history.pushState(url, 'North Texas Pigeon', url)

    FB.XFBML.parse()
    ga('send', 'pageview')

  ###
  load correct page on browser navigation (back button)
  ###
  $(window).on 'popstate', (e) ->
    $('#stage').replaceWith(getPage(e.originalEvent.state))

  ###
  intercepts anchor clicks and navigates to the
  appropriate page
  ###
  $(document).on 'click', 'a:not(.admin-link)', (e) ->
    
    if (!$(@).attr('target'))
      e.preventDefault()

      navigate($(@).attr('href'))

  ###
  preloads pages after hovering on link for 150ms
  ###
  $(document).on 'mouseenter touchstart', 'a', (e) ->
    timer = setTimeout ->
              getPage($(@).attr('href'))
            , 150
    
    $(@).on 'mouseleave', (e) ->
      if timer
        clearTimeout(timer)

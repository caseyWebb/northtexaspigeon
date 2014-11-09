do ->

  registerListenerIfApplicable = ->

    @url = History.getState().data.url
    @page = 1

    pagesWithInfiniteScrolling = ['/category/news',
                                  '/category/columns',
                                  '/picture',
                                  '/video']
    
    return if pagesWithInfiniteScrolling.indexOf(@url) < 0

    $(window).on 'scroll.infinite', =>

      # scroll event is fired many times
      # a second and can prevent laggy UI;
      # throttle this handler to prevent

      return if @throttle || @working
      @throttle = true
      setTimeout =>
        @throttle = false
      , 500

      scrollPos = $(window).scrollTop()
      deviceHeight = $(window).height()
      docHeight = $(document).height()
      distFromBottom = docHeight - (scrollPos + deviceHeight)

      if distFromBottom < deviceHeight

        @working = true
        @page ?= 1

        $.ajax
          url: @url
          data:
            noLayout:true, forceHTML:true, page: @page++
          async: false
          success: (htmlPartial) =>

            ###
            this is a dirty hack to see if we've reached the end of
            the page. it's fast and reliable... enough...
            ###
            if htmlPartial.length < 300
              @working = false
              return $(window).off('scroll.infinite')

            $('#stage').append(htmlPartial)
            @working = false

  # page load
  registerListenerIfApplicable()

  # page change
  History.Adapter.bind window, 'statechange', ->
    $(window).off('scroll.infinite')
    registerListenerIfApplicable()

  
    

    
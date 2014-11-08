do ->

  registerListenerIfApplicable = ->

    $(window).off('scroll.infinite')

    @url = History.getState().data.url
    @endReached = false
    @page = 1

    if @url == '/category/news' || '/category/columns' || '/picture' || '/video'

      $(window).on 'scroll.infinite', =>

        # scroll event is fired many times
        # a second and can prevent laggy UI;
        # throttle this handler to prevent

        return if @throttle || @working || @endReached
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
                @endReached = true
                return

              $('#stage').append(htmlPartial)
              @working = false

  # page load
  registerListenerIfApplicable()

  # page change
  History.Adapter.bind window, 'statechange', ->
    registerListenerIfApplicable()

  
    

    
do ->

  ads = []

  getAds = (next) ->
    $.get '/advertisement', (_ads) ->
      ads = _ads
      next()

  changeAds = ->
    if !@index?
      # start at random index
      @index = Math.floor(Math.random() * (ads.length)) - 1

    # cycle ads
    @index = ++@index % ads.length

    topAd = ads[@index]
    sideAd = ads[Math.floor((@index + (ads.length / 2)) % ads.length)]

    $('#vertical-ad').html """
      <a href="#{sideAd.desktopLink}" target="_blank">
        <img src="#{sideAd.images.vertical}">
      </a>
      """

    $('#horizontal-ad').html """
      <a href="#{topAd.desktopLink}" target="_blank">
        <img src="#{topAd.images.horizontal}">
      </a>
      """

    $('#mobile-ad').html """
      <a href="#{topAd.mobileLink}" target="_blank">
        <img src="#{topAd.images.mobile}">
      </a>
      """

    setTimeout ->
      changeAds()
    , 15000

  $(window).on 'popstate', (e) ->
    changeAds()

  getAds changeAds
$('#mobileNavExpand').click (e) ->
  $('nav > ul').toggleClass('expanded')

  $('nav li:not(#mobileNavExpand) a').on 'click.closeNav', (e) ->
    $('nav > ul').toggleClass('expanded')
    $("nav li:not(#mobileNavExpand) a").off '.closeNav'
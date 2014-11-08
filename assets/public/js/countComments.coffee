window.fbAsyncInit = ->
  FB.Event.subscribe 'comment.create', ->
      $.post "#{window.location.href.replace(window.location.hash, '')}/comment"
@MobileNav = 
  init: ->
    $('#js-mobile-menu').on 'click', (e) ->
      e.preventDefault()
      $('#overlay-nav').slideToggle()
    $('.close').on 'click', (e) ->
      e.preventDefault()
      $('#overlay-nav').slideToggle()


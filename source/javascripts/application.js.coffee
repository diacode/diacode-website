#= require_tree ./vendor
#= require_tree ./lib

$ ->
  $('#main_nav').stickyNavigation()
  $('#testimonials').testimonialSlides()

  $('#js-mobile-menu').on 'click', (e) ->
    e.preventDefault()
    $('#overlay-nav').slideToggle()
  $('.close').on 'click', (e) ->
    e.preventDefault()
    $('#overlay-nav').slideToggle()


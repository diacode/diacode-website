#= require_tree ./vendor
#= require_tree ./lib

$ ->
  $('#main_nav').stickyNavigation()

  $('pre code').each (i, block) ->
    hljs.highlightBlock block

  $('#js-mobile-menu').on 'click', (e) ->
    e.preventDefault()
    $('#overlay-nav').slideToggle()
  $('.close').on 'click', (e) ->
    e.preventDefault()
    $('#overlay-nav').slideToggle()


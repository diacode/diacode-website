#= require_tree ./vendor
#= require_tree ./lib

$ ->
  $('#main_nav').headroom
    'offset': 59
    'tolerance': 5
    'classes':
      'initial': 'animated'
      'pinned': 'slideDown'
      'unpinned': 'slideUp'

  $('pre code').each (i, block) ->
    hljs.highlightBlock block

  MobileNav.init()
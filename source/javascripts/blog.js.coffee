#= require_tree ./vendor
#= require_tree ./lib

$ ->
  if $('.blog-posts').length
    $('#main_nav').stickyNavigation()
  else
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
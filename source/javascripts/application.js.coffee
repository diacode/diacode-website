#= require_tree ./vendor
#= require_tree ./lib

$ ->
  $('#main_nav').stickyNavigation()
  $('#testimonials').testimonialSlides()
  MobileNav.init()

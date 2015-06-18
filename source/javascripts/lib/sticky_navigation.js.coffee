do ($ = jQuery, window, document) ->
  pluginName = "stickyNavigation"
  defaults =
    offsetSelector: '#main_header'

  class Plugin
    constructor: (@element, options) ->
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      @$el = $(@element)
      $(window).on 'resize', @initNav
      @offset = $(@settings.offsetSelector).height()
      @initNav()

    initNav: =>
      windowWidth = $(window).width()
      @$el.slideDown(0) if @$el.is(':hidden') && windowWidth > 480

      if $(document).scrollTop() > @offset || @offset is null
        @$el.addClass("sticky")
      else
        @$el.removeClass("sticky")
      $(window).on "scroll", @manageScroll

    manageScroll: =>
      windowWidth = $(window).width()
      e = $(document).scrollTop()
      if e > @offset && ! @$el.hasClass('sticky')
        @$el.hide().addClass("sticky")
        @$el.fadeIn()
      else if e < @offset
        @$el.removeClass("sticky")

  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Plugin(@, options))

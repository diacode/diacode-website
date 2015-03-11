do ($ = jQuery, window, document) ->
  pluginName = "testimonialSlides"
  defaults = {}
  class Plugin
    constructor: (@element, options) ->
      @settings = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = pluginName
      @init()

    init: ->
      @$el = $(@element)
      @currentIdx = 0
      @slidesCount = @$el.find('.testimonial').length
      
      @goTo(0)

      @bindDots()
      @initTimer()

    bindDots: =>
      @$el.on 'click', '.dot', (evt) =>
        dot = $(evt.currentTarget)
        idx = dot.data('idx')
        @goTo(idx)

    initTimer: =>
      setInterval( =>
        @goToNext()
      , 8000)

    goToNext: =>
      if @currentIdx+1 == @slidesCount
        @goTo(0)
      else
        @goTo(@currentIdx+1)

    goTo: (idx) =>
      @currentIdx = idx
      @$el.find('.testimonial').removeClass('visible')
      @$el.find(".testimonial:nth-child(#{idx+1})").addClass('visible')
      @$el.find(".dot").removeClass('current')
      @$el.find(".dot:nth-child(#{idx+1})").addClass('current')

  $.fn[pluginName] = (options) ->
    @each ->
      if !$.data(@, "plugin_#{pluginName}")
        $.data(@, "plugin_#{pluginName}", new Plugin(@, options))

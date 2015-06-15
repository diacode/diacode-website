@GitHubRepositiories =
  init: ->
    return false unless $('body.open-source').length

    $('body.open-source').find('.project').each (i, ele) ->
      project = $(ele)

      $.ajax
        url: 'https://api.github.com/repos/' + project.data 'repo'
        dataType: 'jsonp'
        success: (results) ->
          data = results.data

          return if results.meta.status >= 400 and data.message

          project.find('.stars').html data.stargazers_count
          project.find('.forks').html data.forks

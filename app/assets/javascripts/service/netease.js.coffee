Service.Netease = (->
  baseURL = '/service/netease/'

  addKeywordHandler = (e)->
    return if e.keyCode isnt 13
    keyword = $(@).val()
    $(@).blur()
    return if keyword.length == 0
    $('#keyword').val('')
    Service.Netease.addKeyword(keyword)

  removeKeywordHandler = (e)->
    id = $(@).data('id')
    Service.Netease.removeKeyword id, ->
      Service.Netease.refresh()

  init: ->
    $('#keyword').keydown addKeywordHandler
    $('#keyword_list').on 'click', '.remove_button', removeKeywordHandler

  refresh: ->
    $('#keyword_list').load(baseURL + '?partial=1')

  removeKeyword: (id, callback = ->)->
    Service.request 'DELETE', baseURL + id, {}, (data, error) ->
      return if error
      callback()

  addKeyword:(keyword)->
    Service.disableElement('#keyword')
    Service.request 'POST', baseURL, {keyword: keyword}, (data, error) ->
      Service.enableElement('#keyword')
      if error
        Service.alert(error.message) if error.message
      else
        Service.Netease.refresh()
)()
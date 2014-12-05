Service.Netease = (->
  baseURL = '/service/netease/'

  addKeywordHandler = (e)->
    return if e.keyCode isnt 13
    keyword = $(@).val()
    $(@).blur()
    return if keyword.length == 0
    $('#keyword').val('')
    Service.Netease.addKeyword(keyword)

  editKeyword = (id)->
    url = baseURL + id + '/edit'
    $('#modal-content').load(url, ->
      $('#modal').modal()
    )

  removeKeywordHandler = (e)->
    id = $(@).data('id')
    Service.Netease.removeKeyword id, ->
      Service.Netease.refresh()

  editHandler = (e)->
    id = $(@).data('id')
    editKeyword(id)

  init: ->
    $('#keyword').keydown addKeywordHandler
    $('#keyword_list').on 'click', '.remove_button', removeKeywordHandler
    $('#keyword_list').on 'click', '.edit_button', editHandler

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
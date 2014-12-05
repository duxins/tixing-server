Service.Weibo = (->
  baseURL = '/service/weibo/'

  refreshUserList= (callback) ->
    Service.disableElement('#nickname')
    url = baseURL + '?partial=1'
    $('#user_list').load(url, ->
      Service.enableElement('#nickname')
    )

  searchUser = ()->
    nickname = $('#nickname').val().trim()
    return if nickname.length <= 1
    Service.Weibo.follow nickname, (data, error)->
      $('#nickname').val('')
      return Service.alert(error.message) if error and error.message
      refreshUserList()

  editUser = (id)->
    url = baseURL + id + '/edit'
    $('#modal-content').load(url, ->
      $('#modal').modal()
    )

  unfollowHandler = ->
    userId = $(@).data 'user-id'
    Service.Weibo.unfollow userId, (data, error)=>
      $(@).parents('.user_container').remove() if !error

  soundHandler = ->
    val = $(@).val()
    return if val == ''
    Service.playSound(val)

  editHandler = ->
    userId = $(@).data 'user-id'
    editUser(userId)

  follow: (nickname, callback)->
    url = baseURL + 'following/' + nickname
    Service.request 'PUT', url, {}, callback

  unfollow: (userId, callback)->
    url = baseURL + 'following/' + userId
    Service.request 'DELETE', url, {}, callback

  # 初始化
  init: ->
    refreshUserList()
    $('#search_form').submit -> false
    $('#user_list').on 'click', '.unfollow-button', unfollowHandler
    $('#user_list').on 'click', '.edit-button', editHandler
    $('#modal').on 'change', '#sound_name', soundHandler
    $('#nickname').keydown (e)->
      return if e.keyCode isnt 13
      $(@).blur()
    $('#nickname').blur (e)->
      searchUser()
)()



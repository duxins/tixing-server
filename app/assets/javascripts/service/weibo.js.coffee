Service.Weibo = (->
  baseURL = '/service/weibo/'

  # Event Handlers
  searchHandler = (e)->
    return if e.keyCode isnt 13
    nickname = $(@).val().trim()
    $(@).val('').blur()

    Service.Weibo.follow nickname, (data, error)->
      if error
        Service.alert(error.message) if error.message
      else
        insertUser data

  unfollowHandler = ->
    userId = $(@).data 'user-id'
    Service.Weibo.unfollow userId, (data, error)=>
      $(@).parents('.user_container').remove() if !error

  # Helper Methods
  insertUser = (user)->
    html = """
            <div class="col-xs-12 col-sm-6 col-md-4 user_container">
              <div class="user_item">
                <div class="row">
                  <div class="col-xs-8 vcenter">
                    <img src="#{user.avatar}" alt="" class="avatar"/>
                    <span class="name">#{user.name}</span>
                  </div><!--
               --><div class="col-xs-4 vcenter">
                    <input type="button" class='btn btn-danger btn-xs pull-right unfollow-button' data-user-id='#{user.id}' value="取消关注"/>
                  </div>
                </div>
              </div>
            </div>
           """
    $(html).appendTo($('#user_list'))

  # 获取关注列表
  list: (callback) ->
    callback ||= ->

    Service.disableElement('#nickname')
    url = baseURL + 'following'

    Service.request 'GET', url, (data, error)->
      Service.enableElement('#nickname')
      return if error
      for user in data
        insertUser user

  # 关注用户
  follow: (nickname, callback)->
    url = baseURL + 'following/' + nickname
    Service.request 'PUT', url, callback

  # 取消关注
  unfollow: (userId, callback)->
    url = baseURL + 'following/' + userId
    Service.request 'DELETE', url, callback

  # 初始化
  init: ->
    Service.Weibo.list()
    $('#search_form').submit -> false
    $('#user_list').on 'click', '.unfollow-button', unfollowHandler
    $('#nickname').keydown searchHandler

)()



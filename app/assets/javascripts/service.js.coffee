#= require jquery
#= require jquery_ujs
#= require bootstrap-sprockets
#= require nprogress
#= require nprogress-turbolinks
#= require nprogress-ajax
#= require_self
#= require_tree ./service

window.Service = (->
  version = 1.0

  request: (method, url, callback)->
    callback ||= ->
    $.ajax
      type: method
      datatype: 'json'
      url: url
    .done (data)->
      callback data, data.error
    .fail (_, __, error)->
      callback null, error

  alert: (msg)->
    if TixingBridge? and TixingBridge.alert
      TixingBridge.alert msg
    else
      alert msg

  goBack: ->
    TixingBridge.goBack() if TixingBridge?

  uninstall: ->
    TixingBridge.uninstallService() if TixingBridge?

  reload: ->
    location.reload()

  disableElement: (elem)->
    $(elem).attr 'disabled', 'disabled'
  enableElement: (elem)->
    $(elem).attr 'disabled', false

)()

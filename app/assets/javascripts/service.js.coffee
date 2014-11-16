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

  request: (method, url, data = {}, callback = ->)->
    $.ajax
      type: method
      datatype: 'json'
      data: data
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

  scanQRCode: (callback)->
    TixingBridge.scanQRCode(callback)

  uninstall: ->
    TixingBridge.uninstallService() if TixingBridge?

  reload: ->
    location.reload()

  disableElement: (elem)->
    $(elem).attr 'disabled', 'disabled'
  enableElement: (elem)->
    $(elem).attr 'disabled', false

)()

$(document).ready ->
  controller = $(document.body).data('controller')
  if controller
    controller = controller[0].toUpperCase() + controller[1..-1].toLowerCase()
    Service[controller].init() if Service[controller] and Service[controller].init

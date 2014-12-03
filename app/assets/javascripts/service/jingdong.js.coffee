Service.Jingdong = (->
  baseURL = '/service/jingdong/'

  parseQRCode = (code)->
    match = /^http:\/\/m.jd.com\/product\/(\d+)\.html/.exec code
    return Service.alert('解析二维码失败') if match == null
    product_number = match[1]
    searchProduct product_number

  searchProduct = (product_number)->
    url = baseURL + 'search/' + product_number
    $('#monitoring_modal_content').load(url, (responseText, statusText, xhr)->
      if statusText == 'error'
        error = JSON.parse(responseText)
        Service.alert(error.error.message)
      else
        $('#monitoring_modal').modal()
        $('#threshold-input').focus()
    )


  editHandler = (e)->
    id = $(@).data('id')
    url = baseURL + id + '/edit'
    $('#monitoring_modal_content').load(url, ->
      $('#monitoring_modal').modal()
      $('#threshold-input').focus()
    )

  removeHandler = (e)->
    id = $(@).data('id')
    url = baseURL + id
    Service.request 'DELETE', baseURL + id, {}, (data, error) ->
      return if error
      refreshProductList()

  refreshProductList = ->
    url = baseURL + '?partial=1'
    $('#product_list').load(url, ->
      $('img').unveil()
    )

  scanHandler = (e)->
    Service.scanQRCode(parseQRCode)

  searchHandler = (e)->
    number = $(@).val().trim()
    $(@).val('')
    return if number.length < 5
    searchProduct number

  init: ->
    $('#qr_button').click scanHandler
    $('#product_list').on 'click', '.edit_button', editHandler
    $('#product_list').on 'click', '.remove_button', removeHandler
    $('#product_number').blur searchHandler
    $('#product_list img').unveil()

  refresh: ->
    refreshProductList()
)()
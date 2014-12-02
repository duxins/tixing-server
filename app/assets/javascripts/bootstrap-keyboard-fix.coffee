#Taken from https://github.com/twbs/bootstrap/issues/9023#issuecomment-45570888
$(document).ready ->
  return unless navigator.userAgent.match /537\.51\.1/
  $('.modal').on 'show.bs.modal', ->
    setTimeout(->
      scrollLocation = $(window).scrollTop
      $('.modal').addClass('modal-ios')
        .height($(window).height())
        .css({'margin-top': scrollLocation + 'px'});
    , 0)

  $('input').on 'blur', ->
    setTimeout(->
      $(window).scrollLeft(0)
      $focused = $(':focus');
      if(!$focused.is('input'))
        $(window).scrollTop scrollLocation
    , 0)


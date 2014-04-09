window.initDatetimepicker = () ->
  $('.datetimepicker').datetimepicker
    language: 'ru'
    weekStart: 1
    orientation: "auto top"
    format: "dd.mm.yyyy HH:i"

$ ->
  window.initDatetimepicker()

$(document)
  .on 'click', '.js-edit', (e) ->
    e.preventDefault()
    url = $(@).data "url"
    $.get url, (data) ->
      $.colorbox
        html: data
        width: '500px'
        onComplete: () ->
          window.initDatetimepicker()

  .on "ajax:success", 'form.edit_task', (e) ->
    $.colorbox.close()

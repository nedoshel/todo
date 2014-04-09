class Sync.TaskListView extends Sync.View

  beforeInsert: ($el) ->
    $el.hide()
    @insert($el)

  afterInsert: ->
    @$el.fadeIn 'slow'
    $('form.new_task')[0].reset()

  beforeRemove: -> @$el.fadeOut 'slow', => @remove()

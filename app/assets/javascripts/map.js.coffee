$ ->
  $('#attackModal').on 'show.bs.modal', (event) ->
    button = $(event.relatedTarget)
    modal = $(this)

    modal.find('#movement_target_id').val(button.data('target-id'))
    modal.find('#target').text(button.data('target-name'))

  $('#attackButton').on 'click', (event) ->
    $(this).parent().parent().find('form').submit()

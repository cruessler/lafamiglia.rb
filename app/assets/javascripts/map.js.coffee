$ ->
  $('#attackButton').on 'click', (event) ->
    $(this).parent().parent().find('form').submit()

  $('div.map .villa').on 'click', (event) ->
    villa = $(event.target)
    template = null

    if villa.hasClass('foreign')
      template = HandlebarsTemplates['map/selected-foreign']
      modal = $('#attackModal')

      modal.find('#movement_target_id').val(villa.data('target-id'))
      modal.find('#target').text(villa.data('target-name'))
    else
      template = HandlebarsTemplates['map/selected-own']

    params =
      href: villa.data("target-href")
      'map-href': villa.data("target-map-href")
      name: villa.data("target-name")

    actionBar = $('#map-actions').html(template(params))

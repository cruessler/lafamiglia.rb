class MultiSelector extends @lafamiglia.AbstractSelector
  constructor: (element) ->
    @objectKey = 'name'
    @displayKey = 'name'

    super element, true

    @selectedElements = {}

    for o in $(@element).data('objects')
      this.addObject o

  createInputsForSubmission: () ->
    name = $(@element).data('name')

    for id, e of @selectedElements
      input = $ '<input></input>'
      input.attr
        type: 'hidden'
        name: "#{name}[]"
        value: id
      $(@form).append input

  objectSelected: (object) ->
    this.addObject(object)
    $(@typeaheadElement).typeahead('val', null)

  addObject: (object) ->
    unless @selectedElements[object.id]
      newElement = $(this.template('selected')(object))
      $(@element).children().last().before(newElement)
      @selectedElements[object.id] = newElement

      newElement.find("a.remove-#{@objectNameSingular}").on 'click', () =>
        this.removeObject(object)

  removeObject: (object) ->
    @selectedElements[object.id].remove()
    delete @selectedElements[object.id]

class @lafamiglia.PlayerSelector extends MultiSelector
  constructor: (element) ->
    @objectNameSingular = 'player'
    @objectNamePlural = 'players'

    super element

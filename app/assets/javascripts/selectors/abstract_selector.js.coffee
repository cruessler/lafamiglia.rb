class @lafamiglia.AbstractSelector
  constructor: (@element, @onTheFlyCreation) ->
    @objectUrl = lafamiglia.urls.root + @objectNamePlural

    this.initializeTypeahead()

    @form = $(@element).closest('form')
    @form.on 'submit', (event) =>
      this.createInputsForSubmission()

  template: (template) ->
    HandlebarsTemplates["#{@objectNamePlural}/#{template}"]

  initializeBloodhound: () ->
    @bloodhound = new Bloodhound(
      datumTokenizer: Bloodhound.tokenizers.obj.whitespace('name')
      queryTokenizer: Bloodhound.tokenizers.whitespace
      limit: 10
      remote:
        url: "#{@objectUrl}/search/%QUERY"
    )

    @bloodhound.initialize()

  initializeTypeahead: () ->
    this.initializeBloodhound()

    datasets = [
      name: @objectNamePlural
      displayKey: @displayKey
      templates:
        header: this.template 'typeahead/header'
        suggestion: this.template 'typeahead/suggestion'
      source: @bloodhound.ttAdapter()
    ]

    @typeaheadElement = $(@element).find(".#{@objectNameSingular}-search")
    @typeaheadElement.typeahead
      minLength: 1
      datasets...

    @typeaheadElement.on 'typeahead:selected', (event, selectedObject, dataset) =>
      this.objectSelected(selectedObject)

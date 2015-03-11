class window.BallotRequest extends Backbone.Model
  defaults:
    stuff: ["hey", "ya"]



class window.BallotRequestView extends Backbone.View

  el: "#ballot_request_view"

  events:
    "click .submit": "submit"
    "change input,select,textarea" : "changed"

  changed: (evt) ->
    $changed = $(evt.currentTarget)
    value = $changed.val()
    field = $changed.data('field-name')
    @model.set(field, value)

  submit: ->
    console.log("should submit")

  initialize: ->
    @listenTo(@model, "change", @render);
    @render()

  render: ->
    @$el.html(@template(@model.attributes))
    return this

  template: (attributes)->
    JST["forms/ballot_request"](attributes)

$ ->
  request_model = new BallotRequest()
  request_view = new BallotRequestView(model: request_model)
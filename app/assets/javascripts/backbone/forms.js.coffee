class window.BallotRequest extends Backbone.DeepModel
  defaults:
    current_address: {country: "USA"}
    registered_address: { state: "", country: "USA" }
    name: {}

  type: () ->
    state = @get('registered_address').state.toLowerCase()
    return "#{state}_ballot_request" if state.length
    return "ballot_request"

  authenticity_params: () ->
    params = []
    params[$("meta[name='csrf-param']").attr('content')] =
           $("meta[name='csrf-token']").attr('content')
    return params

  save: () ->
    type = @type()
    params = @authenticity_params()
    params[type] = @toJSON()
    BVUtils.post('/'+type+'s', params)



class window.BallotRequestView extends Backbone.View

  el: "#ballot_request_view"

  events:
    "click .submit": "submit"
    "change input,select,textarea" : "changed"

  changed: (evt) ->
    $changed = $(evt.currentTarget)
    @changed_id = $changed.attr('id')
    value = $changed.val()
    field = $changed.data('field-name')
    @model.set(field, value)

  submit: ->
    @model.save()

  initialize: ->
    @listenTo(@model, "change", @render);
    @render()

  render: ->
    @$el.html(@template(@model.attributes))
    # re-rendering obliterates tab-next, so manually re-focus
    $('#'+@changed_id).nextAll('input').first().focus() if @changed_id
    return this

  template: (attributes)->
    JST["forms/ballot_request"](attributes)

$ ->
  request_model = new BallotRequest()
  request_view = new BallotRequestView(model: request_model)
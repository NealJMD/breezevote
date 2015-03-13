
_.extend Backbone.Validation.callbacks, 
  valid: (view, attr, selector) ->
    selector = '#'+attr.split(".").join("_")
    $parent = view.$(selector).parents('.field')
    $parent.removeClass('error')
    $parent.find(".inline-error").remove()
    console.log(attr, selector)
  invalid: (view, attr, error, field) ->
    selector = '#'+attr.split(".").join("_")
    $parent = view.$(selector).parents('.field')
    $parent.addClass('error')
    $parent.prepend("<label class='inline-error'>#{error}</label>")
    console.log(attr, error, selector)

class window.BallotRequest extends Backbone.DeepModel
  defaults:
    current_address: {country: "USA"}
    registered_address: { state: "", country: "USA" }
    name: {}

  validation: 
    'registered_address.street_address':
      required: true
    'registered_address.city':
      required: true
    'registered_address.state':
      required: true
      length: 2
    'registered_address.zip':
      required: true
      length: 5
      msg: 'Zip code must be 5 digits'
    'registered_address.country':
      oneOf: ['USA']
      required: true
      msg: 'You must be registered to vote in the USA.'
    'current_address.street_address':
      required: true
    'current_address.city':
      required: true
    'current_address.country':
      required: true
    'name.first_name': 
      required: true
    'name.last_name':
      required: true

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
    @validate()
    if @isValid()
      type = @type()
      params = @authenticity_params()
      params[type] = @toJSON()
      # BVUtils.post('/'+type+'s', params)
    else
      console.log("validation failed")



class window.BallotRequestView extends Backbone.View

  el: "#ballot_request_form"

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
    @listenTo(@model, "change", @render)
    Backbone.Validation.bind this
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
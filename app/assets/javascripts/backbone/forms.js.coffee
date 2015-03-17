
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

  isNew: () ->
    return !@get('id')?

  initialize: () ->
    # some values exist only in the client side. we reconstruct them here
    switch @get('registered_address.state')
      when 'NC'
        @set('identification', 'ssn_four') if @get('ssn_four')?
        @set('identification', 'license_number') if @get('license_number')?

  save: () ->
    @validate()
    if @isValid()
      type = @type()
      params = @authenticity_params()
      params[type] = @toJSON()
      if @isNew()
        console.log("is new, calling to",'/'+type+'s')
        BVUtils.post('/'+type+'s', params)
      else
        console.log("is old, calling to",'/'+type+'s/'+@get('id'))
        BVUtils.post('/'+type+'s/'+@get('id'), params, 'put')
    else
      console.log("validation failed")



class window.BallotRequestView extends Backbone.View

  el: "#ballot_request_form"

  events:
    "click .submit": "submit"
    "change input,select,textarea" : "changed"
    "cut input,select,textarea" : "changed"
    "paste input,select,textarea" : "changed"

  changed: (evt) ->
    $changed = $(evt.currentTarget)
    value = $changed.val()
    field = $changed.data('field-name')
    @model.set(field, value)

  submit: ->
    @model.save()

  initialize: ->
    @listenTo(@model, "change", @update)
    Backbone.Validation.bind this
    @render()
    @update()

  update: () ->
    conditions = _.map @$("[data-reveal-field]"), (f) ->
      $f = @$(f)
      [$f.data('reveal-field'), String($f.data('reveal-value')), $f]
    for [field, desired, $f] in conditions
      actual = String(@model.get(field))
      if actual is desired or (desired is '*' and actual?)
        $f.show()
      else
        $f.hide()

    console.log(@model.attributes)

  render: ->
    @$el.html(@template(@model.attributes))
    return this

  template: (attributes)->
    JST["forms/ballot_request"](attributes)

$ ->
  init = window.BVDoc || {}
  request_model = new BallotRequest(init)
  request_view = new BallotRequestView(model: request_model)
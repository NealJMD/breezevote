
class window.BallotRequest extends Backbone.DeepModel
  defaults:
    current_address: {country: "USA"}
    registered_address: { state: "", country: "USA" }
    name: {}
    user: {}

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
    'user.email':
      required: true,
      pattern: 'email'
    'user.password':
      minLength: 8

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

  multipart_keys: () ->
    # some keys should not be nested on submission, but are nested in this model
    return ['user']

  save: () ->
    @validate()
    if @isValid()
      type = @type()
      params = @authenticity_params()
      params[type] = @toJSON()
      for key in @multipart_keys()
        existing = params[type][key]
        if existing?
          params[key] = existing
          delete params[type][key]
      if @isNew()
        console.log("is new, calling to",'/'+type+'s')
        brzvt.utils.post('/'+type+'s', params)
      else
        console.log("is old, calling to",'/'+type+'s/'+@get('id'))
        brzvt.utils.post('/'+type+'s/'+@get('id'), params, 'put')
    else
      console.log("validation failed")



class window.BallotRequestView extends Backbone.View

  el: "#ballot_request_form"

  events:
    "click .submit": "submit"
    "click .next-page": "next_page"
    "click .prev-page": "prev_page"
    "change input,select,textarea" : "changed"
    "cut input,select,textarea" : "changed"
    "paste input,select,textarea" : "changed"
    "blur input,select,textarea" : "changed"
    # "change input,select,textarea" : "prevalidate"

  changed: (evt) ->
    [field, value] = @field_value_from_target(evt.currentTarget)
    @prevalidate(field, value)
    @model.set(field, value)

  submit: ->
    @model.save()

  field_value_from_target: (target) ->
    $changed = $(target)
    value = $changed.val()
    field = $changed.data('field-name')
    return [field, value]

  initialize: ->
    @listenTo(@model, "change", @update)
    Backbone.Validation.bind this
    @render()
    @update()
    @render_server_errors()
    @show_page(@first_page())

  prevalidate: (field, value) ->
    return false if field.indexOf '(' > -1 or field.indexOf ')' > -1
    error_message = @model.preValidate(field, value)
    if error_message
      brzvt.utils.invalid(this, field, error_message)
    else
      brzvt.utils.valid(this, field)
    return not error_message

  validate_page: (page_number) ->
    inputs = $("[data-page-number='#{page_number}'].page").find('input[data-field-name]')
    error_free = true
    for input in inputs
      [field, value] = @field_value_from_target(input)
      error_free = false unless @prevalidate(field, value)
    return error_free

  prev_page: (evt) ->
    @change_page(evt, -1)

  next_page: (evt) ->
    @change_page(evt, +1)

  change_page: (evt, delta) ->
    $clicked = $(evt.currentTarget)
    page_number = $clicked.parents('.page').data('page-number')
    @show_page(page_number+delta) if @validate_page(page_number)
    @scrollTo('#form-top')

  first_page: ->
    if brzvt.errors? then '*' else 1

  show_page: (page_number) ->
    return unless $('.page').length
    for page in $('.page')
      if page_number is '*' or $(page).data('page-number') is +page_number
        $(page).show()
      else
        $(page).hide()
    $('.next-page').hide() if page_number is '*'
    $('.prev-page').hide() if page_number is '*'

  scrollTo: (target) ->
    $('html, body').animate({scrollTop: $(target).offset().top-120}, 400)

  render_server_errors: ->
    return unless brzvt.errors?
    for field, errors of brzvt.errors
      error = brzvt.utils.sentence_case(field) + ' ' + errors[0]
      console.log(field, error)
      brzvt.utils.invalid(this, field, error)

  update: () ->
    conditions = _.map @$("[data-reveal-field]"), (f) ->
      $f = @$(f)
      [$f.data('reveal-field'), $f.data('reveal-value'), $f]
    for [field, desired, $f] in conditions
      actual = @model.get(field)
      if String(actual) is String(desired) or (desired is '*' and actual? and actual.length)
        $f.show()
      else
        $f.hide()

    console.log(@model.attributes)

  render: ->
    @$el.html(@template(@model.attributes))
    return this

  template: (attributes)->
    JST["forms/ballot_request"](attributes)

$(document).on 'page:change', ->
  init = brzvt.doc || {}
  request_model = new BallotRequest(init)
  request_view = new BallotRequestView(model: request_model)
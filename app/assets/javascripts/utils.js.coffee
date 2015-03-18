window.brzvt ||= {}
window.brzvt.utils = 

  valid: (view, attr, field) ->
    selector = '[id='+attr.split(".").join("_")+']'
    $parent = view.$(selector).parents('.field')
    $parent.removeClass('error')
    $parent.find(".inline-error").remove()
    console.log(attr, selector)

  invalid: (view, attr, error, field) ->
    selector = '[id='+attr.split(".").join("_")+']'
    $parent = view.$(selector).parents('.field')
    $parent.addClass('error')
    $parent.prepend("<label class='inline-error'>#{error}</label>")
    console.log(attr, error, field)

  sentence_case: (attrName) ->
    splitted = attrName.split('.');
    query = splitted[splitted.length-1];
    return query.replace(/(?:^\w|[A-Z]|\b\w)/g, (match, index) ->
      return if index is 0 then match.toUpperCase() else ' ' + match.toLowerCase();
    ).replace(/_/g, ' ');

  flatten_params: (params, top_level=true) ->
    output = {}
    for own key, value of params
      if typeof value is "object"
        field = if top_level then key else '['+key+'_attributes]'
        flattened = @flatten_params(value, false)
        for own k, v of flattened
          output[field + k] = v
      else
        field = if top_level then key else '['+key+']'
        output[field] = value
    return output

  post: (path, params, method) ->

    method ?= "post" # Set method to post by default if not specified.

    form = document.createElement("form")
    $(form).attr("method", method).attr("action", path)

    for own field, value of @flatten_params(params)
      hiddenField = document.createElement("input")
      $(hiddenField).attr("type", "hidden").attr("name", field).attr("value", value)
      form.appendChild hiddenField

    document.body.appendChild(form)
    form.submit()

_.extend Backbone.Validation.callbacks, 
  valid: brzvt.utils.valid
  invalid: brzvt.utils.invalid

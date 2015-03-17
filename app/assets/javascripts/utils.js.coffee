window.brzvt ||= {}
window.brzvt.utils = 

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
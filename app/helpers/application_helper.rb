module ApplicationHelper

  def render_value(value)
    ret = value
    case value.class.to_s
    when "Date"
      ret = value.strftime("<div class='month'>%m</div><div class='slash'>/</div>
                            <div class='day'>%d</div><div class='slash'>/</div>
                            <div class='year'>%Y</div>")
    when "TrueClass"
      ret = "&times;"
    when "FalseClass"
      ret = ""
    end
    return ret.to_s.html_safe
  end

end

module ApplicationHelper

  def render_value(value)
    ret = value
    puts value.class.to_s
    case value.class.to_s
    when "Date"
      ret = value.strftime("<div class='month'>%m</div><div class='slash'>/</div>
                            <div class='day'>%d</div><div class='slash'>/</div>
                            <div class='year'>%Y</div>")
    when "TrueClass"
      ret = "<div class='true positioned'>&times;</div>"
    when "FalseClass"
      ret = "<div class='false positioned'>&times;</div>"
    end
    return ret.to_s.html_safe
  end

end

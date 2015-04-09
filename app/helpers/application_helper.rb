module ApplicationHelper

  def asset_data_base64(path)
    asset = Rails.application.assets.find_asset(path)
    raise ArgumentError.new("Could not find asset '#{path}'") if asset.nil?
    base64 = Base64.encode64(asset.to_s).gsub(/\s+/, "")
    "data:#{asset.content_type};base64,#{Rack::Utils.escape(base64)}"
  end

  def render_value(value)
    ret = value
    case value.class.name
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

  def download_link(doc)
    send("download_#{doc.symbol.to_s}_path", doc)
  end

end

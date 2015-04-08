if Rails.env.development? or Rails.env.test?
  WickedPdf.config = {
    :exe_path => "/usr/local/bin/wkhtmltopdf"
  }
end

case Rails.env
when "development"
  DOCUMENT_DPI = 150
  JAVASCRIPT_DELAY = 10 # milliseconds
when "test"
  DOCUMENT_DPI = 75
  JAVASCRIPT_DELAY = 10 # milliseconds
when "production"
  DOCUMENT_DPI = 150
  JAVASCRIPT_DELAY = 10 # milliseconds
end
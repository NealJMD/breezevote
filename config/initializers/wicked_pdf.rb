if Rails.env.development? or Rails.env.test?
  WickedPdf.config = {
    :exe_path => "/usr/local/bin/wkhtmltopdf"
  }
end

case Rails.env
when "development"
  DOCUMENT_DPI = 150
  JAVASCRIPT_DELAY = 10 # milliseconds
  PAPERCLIP_PDF_ASSET_STORAGE_OPTIONS = {
    prefix: "public/system/pdfs/",
    path: "public/system/pdfs/:pdfable_type/:pdfable_id/:filename",
    url: "system/pdfs/:pdfable_type/:pdfable_id/:filename"
  }
when "test"
  DOCUMENT_DPI = 75
  JAVASCRIPT_DELAY = 10 # milliseconds
  PAPERCLIP_PDF_ASSET_STORAGE_OPTIONS = {
    prefix: "public/system/test/pdfs/",
    path: "public/system/test/pdfs/:pdfable_type/:pdfable_id/:filename",
    url: "system/test/pdfs/:pdfable_type/:pdfable_id/:filename"
  }
when "production"
  DOCUMENT_DPI = 150
  JAVASCRIPT_DELAY = 10 # milliseconds
end
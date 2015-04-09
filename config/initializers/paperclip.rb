case Rails.env
when "test"
  PAPERCLIP_PDF_ASSET_STORAGE_OPTIONS = {
    prefix: "public/system/test/pdfs/",
    path: "public/system/test/pdfs/:pdfable_type/:pdfable_id/:filename",
    url: "system/test/pdfs/:pdfable_type/:pdfable_id/:filename"
  } 
when "development"
  PAPERCLIP_PDF_ASSET_STORAGE_OPTIONS = {
    prefix: "public/system/pdfs/",
    path: "public/system/pdfs/:pdfable_type/:pdfable_id/:filename",
    url: "system/pdfs/:pdfable_type/:pdfable_id/:filename"
  }

  ### To debug s3
  # PAPERCLIP_PDF_ASSET_STORAGE_OPTIONS = {
  #   path: "/dev/pdfs/:pdfable_type/:pdfable_id/:filename"
  # }
  # Paperclip::Attachment.default_options.merge!({
  #   :storage => :s3,
  #   :s3_permissions => :private,
  #   :s3_credentials => {
  #   }
  # })
when "production"
   PAPERCLIP_PDF_ASSET_STORAGE_OPTIONS = {
    path: "/pdfs/:pdfable_type/:pdfable_id/:filename"
  }
  Paperclip::Attachment.default_options.merge!({
    :storage => :s3,
    :s3_permissions => :private,
    :s3_credentials => {
      :bucket => ENV['S3_BUCKET_NAME'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  })
end
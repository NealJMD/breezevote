class PdfAsset < ActiveRecord::Base
  belongs_to :pdfable, polymorphic: true

  has_attached_file :pdf,
    {}.merge(PAPERCLIP_PDF_ASSET_STORAGE_OPTIONS)

  validates :pdfable, presence: true
  validates_attachment_content_type :pdf, :content_type => ["application/pdf"]
  validates_attachment_file_name :pdf, :matches => [/pdf\Z/]

  Paperclip.interpolates :pdfable_type do |attachment, style|
    attachment.instance.pdfable_type
  end

  Paperclip.interpolates :pdfable_id do |attachment, style|
    attachment.instance.pdfable_id
  end

end

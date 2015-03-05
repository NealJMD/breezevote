class AddAttachmentPdfToPdfAssets < ActiveRecord::Migration
  def self.up
    add_attachment :pdf_assets, :pdf
  end

  def self.down
    remove_attachment :pdf_assets, :pdf
  end
end

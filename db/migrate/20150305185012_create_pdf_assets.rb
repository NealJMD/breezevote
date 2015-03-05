class CreatePdfAssets < ActiveRecord::Migration
  def change
    create_table :pdf_assets do |t|
      t.references :pdfable, polymorphic: true, index: true
      t.timestamps
    end
  end
end

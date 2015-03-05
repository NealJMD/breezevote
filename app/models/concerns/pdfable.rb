module Pdfable
  extend ActiveSupport::Concern

  included do
    has_one :pdf_asset, as: :pdfable, dependent: :destroy
  end

  def create_pdf
    save_pdf(render_pdf(render_html), render_filename)
  end

  def render_html
    html_string = render_to_string(
      'shared/_document.html.haml',
      :locals => {
        :doc => self,
        :document_name => self.name.underscore
      },
      :layout => 'layouts/pdf.html',
      :javascript_delay => JAVASCRIPT_DELAY,
    )
    return html_string
  end

  def render_pdf(html_string)
    pdf_string = WickedPdf.new.pdf_from_string(
      html_string,
      :dpi => DPI.to_s
    )
    return pdf_string
  end

  def render_filename
    "#{self.name}-#{id}-#{name.safe(:first_name)}-#{name.safe(:last_name)}"
  end

  def save_pdf(pdf_string, pdf_name)
    tempfile = Tempfile.new([pdf_name, ".pdf"], Rails.root.join('tmp'))
    tempfile.binmode
    tempfile.write pdf_string
    tempfile.close

    pdf_asset = PdfAsset.new(pdfable: self)
    pdf_asset.pdf = File.open tempfile.path
    pdf_asset.pdf_file_name = "#{pdf_name}.pdf"
    pdf_asset.save!

    tempfile.unlink
  end

end

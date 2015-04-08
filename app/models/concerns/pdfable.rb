module Pdfable
  extend ActiveSupport::Concern

  included do
    has_one :pdf_asset, as: :pdfable, dependent: :destroy
    after_create :create_pdf, :unless => "Rails.env.test?" # slows tests wayy down
  end

  def has_pdf_asset?
    pdf_asset.present?
  end

  def pdf_url
    return '/' unless has_pdf_asset?
    if Paperclip::Attachment.default_options[:storage] == :filesystem
      return '/'+pdf_asset.pdf.url
    else
      return pdf_asset.pdf.url
    end
  end

  def create_pdf(directive=nil)
    if has_pdf_asset?
      return false unless directive == :overwrite
      pdf_asset.destroy!
    end
    save_pdf(render_pdf(render_html), render_filename)
  end

  def render_html
    html_string = ApplicationController.new.render_to_string(
      'shared/_document.html.haml',
      :locals => {
        :doc => self,
        :document_name => self.class.name.underscore
      },
      :layout => 'layouts/pdf.html',
      :javascript_delay => JAVASCRIPT_DELAY,
    )
    return html_string
  end

  def render_pdf(html_string)
    margin = 10 # mm
    pdf_string = WickedPdf.new.pdf_from_string(
      html_string,
      :dpi => DOCUMENT_DPI.to_s,
      :disable_smart_shrinking        => true,
      :zoom => 0.27,
      :margin => {:top => margin,
                 :bottom => margin,
                 :left => margin,
                 :right => margin},
      :page_size => 'letter',
      # :width => 2410,
      # :height => 3050
     # :grayscale                      => true
    )
    return pdf_string
  end

  def render_filename
    "#{self.class.name}-#{id}-#{name.safe(:first_name)}-#{name.safe(:last_name)}"
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
    return true
  end

end

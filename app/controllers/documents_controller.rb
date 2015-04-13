class DocumentsController < ApplicationController
  before_action :set_type
  before_action :set_document, only: [:show, :edit, :update, :destroy, :preview, :download]

  def index
    redirect_to(root_path)
  end

  def show
  end

  def preview
    render :preview, layout: 'pdf'
  end

  def download
    if not @document.has_pdf_asset?
      redirect_to @document, notice: 'That document is not yet ready.'
    elsif Paperclip::Attachment.default_options[:storage] == :filesystem
      redirect_to '/'+@document.pdf_asset.pdf.url
    else
      redirect_to @document.pdf_asset.pdf.expiring_url(10) # for s3
    end
  end

  def new
    @document = model.new
  end

  def edit
  end

  def create
    @document = model.new(strong_params)
    return render :new unless @document.valid?

    errors = authenticate_or_errors
    if errors.present?
      merge_errors(@document, errors, 'user')
      return render :new
    end

    # if we've made it this far, we know we have a valid user and a valid document
    # time to save and associate
    success = false
    @document.transaction do
      @document.save!
      @document.reload
      sub = Submission.new({user_id: current_user.id})
      sub.document = @document
      sub.save!
      success = true
    end

    if success
      redirect_to @document, notice: '#{title} was successfully created.'
    else
      render :new
    end
  end

  def update
    if @document.update(strong_params)
      redirect_to @document, notice: '#{title} was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to :index, notice: '#{title} was successfully destroyed.'
  end

  private

    def set_type
      @type = params[:type]
      @state = @type.slice(0,2).upcase
    end
    
    def set_document
      @document = model.find(params[:id])
      not_found if @document.blank? || @document.user.blank? || @document.user != current_user
    end

    def model
      begin
        @type.constantize
      rescue NameError => e
        redirect_to root_path
      end
    end

    def title
      @type.titleize
    end

    def symbol
      @type.underscore.to_sym
    end

    def path(action, id=nil)
      method = @type.underscore
      if action == :new || action == :edit
        method.prepend(action.to_s+'_')
      elsif action == :index || action == :create
        method.append('s')
      end
      method.append("(#{id})") if id.present?
      return eval method
    end

    def address_strong_params
      address_fields = [:street_address, :apartment, :city, :state, :zip, :country]
      { 
        name_attributes: [:first_name, :last_name, :middle_name, :suffix],
        registered_address_attributes: address_fields,
        current_address_attributes: address_fields
      }
    end

    def document_params
      [:status]
    end

    def strong_params
      params.require(symbol).permit(*model.other_params, *document_params, **address_strong_params)
    end
end

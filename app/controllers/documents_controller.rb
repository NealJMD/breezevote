class DocumentsController < ApplicationController
  before_action :set_type
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  def index
    @documents = model.all
  end

  def show

  end

  def new
    @document = model.new
  end

  def edit
  end

  def create
    @document = model.new(strong_params)

    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: '#{title} was successfully created.' }
        format.json { render json: { redirect: path(:show, @document.id) }, status: 201 }
      else
        format.html { render :new }
        format.json { render json: { errors: @document.errors }, status: 422 }
      end
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

    def other_params
      [:ssn_four, :reason_code, :reason_support, :license_number, :moved_recently, :date_moved, :birthdate]
    end

    def strong_params
      params.require(symbol).permit(*other_params, **address_strong_params)
    end
end

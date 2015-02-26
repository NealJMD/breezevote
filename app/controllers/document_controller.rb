class DocumentController < ApplicationController
  before_action :set_document, only: [:show, :edit, :update, :destroy]

  ### # # # # # # # # # # # # # # # # #
  #
  # To inherit from this controller, you need to implement two private methods
  #
  #  def model
  #    VaBallotRequest
  #  end
  #
  #  def whitelisted_params
  #    params.require(:va_ballot_request).permit(:name_attributes, :registered_address_attributes ...)
  # end
  #
  ### # # # # # # # # # # # # # # # # #

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
    @document = model.new(whitelisted_params)

    if @document.save
      redirect_to @document, notice: 'Va ballot request was successfully created.'
    else
      render :new
    end
  end

  def update
    if @document.update(whitelisted_params)
      redirect_to @document, notice: 'Va ballot request was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @document.destroy
    redirect_to :index, notice: 'Va ballot request was successfully destroyed.'
  end

  private
    def set_document
      @document = model.find(params[:id])
    end

    def address_strong_params
      address_fields = [:street_address, :apartment, :city, :state, :zip, :country]
      { 
        name_attributes: [:first_name, :last_name, :middle_name, :suffix],
        registered_address_attributes: address_fields,
        current_address_attributes: address_fields
      }
    end
end

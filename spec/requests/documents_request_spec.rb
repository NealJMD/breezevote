describe DocumentsController, :type => :request do

  let(:class_sym) { [:va_ballot_request, :nc_ballot_request].sample }
  let(:model) { class_sym.to_s.camelcase.constantize }
  let(:params) { params_for(model, class_sym) }
  let(:class_name) { class_sym.to_s }
  let(:base_path) { "/#{class_name.pluralize}" }
  let(:bad_params) { params_for(model, class_sym) }

  before :each do
    bad_params[:name_attributes][:first_name] = "    "
  end

  describe :create do

    describe :html do

      describe :success do
        it "should save" do
          expect{ post base_path, class_sym => params }.to change{ model.count }.by 1
          expect(model.last.name.first_name).to eq params[:name_attributes][:first_name]
          expect(response).to redirect_to(model.last)
        end

        it "should save two addresses" do
          expect{ post base_path, class_sym => params }.to change{ Address.count }.by 2
        end

        it "should save one name" do
          expect{ post base_path, class_sym => params }.to change{ Name.count }.by 1
        end
      end

      describe :rejection do

        it "should not save" do
          expect{ post base_path, class_sym => bad_params }.to change{ model.count }.by 0
          expect(response).to be_success
          expect(response).to render_template :new
        end

        it "should save zero addresses" do
          expect{ post base_path, class_sym => bad_params }.to change{ Address.count }.by 0
        end

        it "should save zero names" do
          expect{ post base_path, class_sym => bad_params }.to change{ Name.count }.by 0
        end
      end
    end

  end


  describe :update do

    let(:first_name) { "Jimmy jim jim" }
    let(:address) { "1 Infinite Loop"}

    before :each do
      model.new(params).save!
      @existing = model.last
      @last_updated = @existing.updated_at
      @path = "#{base_path}/#{@existing.id}"
      @new_params = params
      @new_params[:name_attributes][:first_name] = first_name
      @new_params[:current_address_attributes][:street_address] = address
    end

    describe :html do

      describe :success do
        it "should redirect" do
          expect{ put @path, class_sym => @new_params }.to change{ model.count }.by 0
          expect(response).to redirect_to(model.last)
        end

        it "should update existing addresses" do
          expect{ put @path, class_sym => @new_params }.to change{ Address.count }.by 0
          expect(model.last.current_address.street_address).to eq address
        end

        it "should update existing name" do
          expect{ put @path, class_sym => @new_params }.to change{ Name.count }.by 0
          expect(model.last.name.first_name).to eq first_name
        end
      end

      describe :rejection do

        it "should not save update timestamp or redirect" do
          expect{ put @path, class_sym => bad_params }.to change{ model.count }.by 0
          expect(model.last.updated_at).to eq @last_updated
          expect(response).to render_template :edit
          expect(response).to be_success
        end

        it "should not update addresses" do
          expect{ put @path, class_sym => bad_params }.to change{ Address.count }.by 0
          expect(model.last.current_address.street_address).not_to eq address
        end

        it "should not update name" do
          expect{ put @path, class_sym => bad_params }.to change{ Name.count }.by 0
          expect(model.last.name.first_name).not_to eq first_name
        end
      end
    end

  end

end
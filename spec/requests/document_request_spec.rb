describe DocumentsController, :type => :request do

  let(:class_sym) { [:va_ballot_request, :nc_ballot_request].sample }
  let(:model) { class_sym.to_s.camelcase.constantize }
  let(:params) { params_for(model, class_sym) }
  let(:class_name) { class_sym.to_s }
  let(:base_path) { "/#{class_name.pluralize}/" }

  describe :create do

    describe :html do
      it "should be successful with good params" do
        expect{ post base_path, class_sym => params }.to change{ model.count }.by 1
        expect(model.last.name.first_name).to eq params[:name_attributes][:first_name]
        expect(response).to redirect_to(model.last)
      end

      it "should be rejected with bad params" do
        expect{ post base_path, class_sym => {herp: "derp"} }.to change{ model.count }.by 0
        expect(response).to be_success
        expect(response).to render_template :new
      end
    end

  end

end
shared_examples "document controller" do |model, class_sym|

  let(:params) { params_for(model, class_sym) }
  let(:class_name) { class_sym.to_s }
  let(:base_path) { "/#{class_name.pluralize}/" }

  describe "#{class_sym} document controller", :type => :request do

    describe :create do

      it "should be successful with good params" do
        expect{ post base_path, class_sym => params }.to change{ model.count }.by 1
        expect(model.last[params.keys.first]).to eq params[params.keys.first]
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
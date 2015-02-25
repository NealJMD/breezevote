shared_examples "addressable" do |model, class_sym|

  let(:params) { params_for(model, class_sym) }

  describe :create do

    describe :successful do

      it "should create two new addresses" do
        expect{ model.create(params) }.to change { Address.count }.by 2
      end

      it "should create one new name" do
        expect{ model.create(params) }.to change { Name.count }.by 1
      end

      it "should create one new #{model}" do
        expect{ model.create(params) }.to change { model.count }.by 1
      end

    end

  end

end
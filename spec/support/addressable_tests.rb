shared_examples "addressable" do |model, class_sym|

  let(:params) { attributes_for(class_sym) }

  before :each do
    puts "model 1 #{model}"
  end

  describe :build do

    describe :successful do

      before :each do
        puts "model 1 #{model}"
      end

      it 'should create two new addresses' do
        puts params[:registered_address]
        expect{ model.build(params) }.to change { Address.count }.by 2
        a = Address.last
        puts a
        puts a.street_address
      end

    end

  end

end
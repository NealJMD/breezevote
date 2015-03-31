describe DocumentsController, :type => :request do

  let(:class_sym) { [:va_ballot_request, :nc_ballot_request].sample }
  let(:model) { class_sym.to_s.camelcase.constantize }
  let(:class_name) { class_sym.to_s }
  let(:base_path) { "/#{class_name.pluralize}" }

  let(:params) { params_for(model, class_sym) }
  let(:bad_params) { params_for(model, class_sym) }

  let(:user_params) { attributes_for :user }
  let(:bad_user_params) { attributes_for :user }


  before :each do
    bad_params[:name_attributes][:first_name] = "    "
    bad_user_params[:password] = "adsf"
  end

  ##### SHARED SPECIFICATIONS

  shared_examples_for "it created a user" do
    it "should create a user" do
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ User.count }.by 1
      expect(User.last.email).to eq ups[:email]
    end
  end
  shared_examples_for "it did not create a user" do
    it "should not create a user" do
      expect{ post base_path, { class_sym => params, user: bad_user_params } }.to change{ User.count }.by 0
    end
  end
  shared_examples_for "it saved a document" do
    it "should save a document" do
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ model.count }.by 1
      expect(model.last.name.first_name).to eq ps[:name_attributes][:first_name]
      expect(model.last.delivery_requested?).to eq true
      expect(model.last.user).not_to be_blank
      expected_email = ups.blank? ? current_email : ups[:email]
      expect(model.last.user.email).to eq expected_email
      expect(response).to redirect_to(model.last)
    end
    it "should save two addresses" do
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ Address.count }.by 2
      expected_addresses = [ps[:current_address_attributes][:street_address], ps[:registered_address_attributes][:street_address]]
      expect(Address.last(2).map(&:street_address)).to match_array(expected_addresses)
    end
    it "should save one name" do
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ Name.count }.by 1
      expect( Name.last.first_name ).to eq ps[:name_attributes][:first_name]
    end
  end
  shared_examples_for "it did not save a document" do
    it "should not save a document" do
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ model.count }.by 0
      expect(model.last.name.first_name).not_to eq ps[:name_attributes][:first_name]
      expect(response).to be_success
      expect(response).to render_template :new
    end
    it "should no addresses" do
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ Address.count }.by 0
      expected_addresses = [ps[:current_address_attributes][:street_address], ps[:registered_address_attributes][:street_address]]
      expect(Address.last(2).map(&:street_address)).not_to match_array(expected_addresses)
    end
    it "should no names" do
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ Name.count }.by 0
      expect( Name.last.first_name ).not_to eq ps[:name_attributes][:first_name]
    end
  end

  ##### CASES AND TESTS

  describe :create do

    describe :not_logged_in do

      describe :new_user do

        describe :good_params do
          let(:ps) { params }
          let(:ups) { user_params }
          it_should_behave_like "it created a user"
          it_should_behave_like "it saved a document"
        end

        describe :bad_params do
          let(:ps) { bad_params }
          let(:ups) { user_params }
          it_should_behave_like "it created a user"
          it_should_behave_like "it did not save a document"
        end

        describe :bad_user_params do
          let(:ps) { params }
          let(:ups) { bad_user_params }
          it_should_behave_like "it did not create a user"
          it_should_behave_like "it did not save a document"
        end

        describe :revised_params do

          before :each do
            expect{ post base_path, { class_sym => bad_params, user: user_params } }.to change{ User.count }.by 1
          end

          let(:ps) { params }
          let(:ups) { nil }
          let(:current_email) { user_params[:email] }
          it_should_behave_like "it did not create a user"
          it_should_behave_like "it saved a document"
        end
      end

      describe :existing_user do

        before :each do
          @user = User.new(user_params)
          @user.save!
        end

        let(:ps) { params }
        let(:ups) { user_params }
        it_should_behave_like "it did not create a user"
        it_should_behave_like "it saved a document"

        describe :incorrect_login do

          before :each do
            @bad_login_params = user_params
            @bad_login_params[:password] = "qwerqwer123!"
          end

          let(:ps) { params }
          let(:ups) { @bad_login_params }
          it_should_behave_like "it did not create a user"
          it_should_behave_like "it did not save a document"
        end
      end

      describe :no_user_params do
        let(:ps) { params }
        let(:ups) { nil }
        it_should_behave_like "it did not create a user"
        it_should_behave_like "it did not save a document"
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
describe DocumentsController, :type => :request do

  let(:class_sym) { [:va_ballot_request, :nc_ballot_request].sample }
  let(:model) { class_sym.to_s.camelcase.constantize }
  let(:class_name) { class_sym.to_s }
  let(:base_path) { "/#{class_name.pluralize}" }
  let(:show_path) { "#{base_path}/#{@doc.id}" }
  let(:other_show_path) { "#{base_path}/#{@other_doc.id}" }

  let(:params) { params_for(model, class_sym) }
  let(:bad_params) { params_for(model, class_sym) }
  let(:other_params) { params_for(model, class_sym) }

  let(:user_params) { attributes_for :user }
  let(:other_user_params) { attributes_for :user }
  let(:bad_user_params) { attributes_for :user }
  let(:login_params) { {email: user_params[:email], password: user_params[:password]} }
  let(:other_login_params) { {email: other_user_params[:email], password: other_user_params[:password]} }
  let(:current_email){ nil }


  before :each do
    @base_instance = create class_sym
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
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ User.count }.by 0
    end
  end
  shared_examples_for "it logged in" do
    it "should be logged in after the request" do
      post base_path, { class_sym => ps, user: ups }
      get edit_user_registration_path
      expect(response).to be_success
      expect(response).to render_template :edit
    end
  end
  shared_examples_for "it did not log in" do
    it "should not be logged in after the request" do
      post base_path, { class_sym => ps, user: ups }
      get edit_user_registration_path
      expect(response).not_to be_success
      expect(response).to redirect_to(new_user_session_path)
    end
  end
  shared_examples_for "it saved a document" do
    it "should save a document" do
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ model.count }.by 1
      expect(model.last.name.first_name).to eq ps[:name_attributes][:first_name]
      expect(model.last.delivery_requested?).to eq true
      expect(response).to redirect_to(model.last)
    end
    it "should associate the document with the user" do
      expect post base_path, { class_sym => ps, user: ups }
      expect(model.last.user).not_to be_blank
      expected_email = current_email.blank? ? ups[:email] : current_email
      expect(model.last.user.email).to eq expected_email
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
    it "should save no addresses" do
      prev_addresses = Address.last(2).map(&:street_address)
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ Address.count }.by 0
      expect(Address.last(2).map(&:street_address)).to match_array(prev_addresses)
    end
    it "should save no names" do
      prev_name = Name.last.first_name
      expect{ post base_path, { class_sym => ps, user: ups } }.to change{ Name.count }.by 0
      expect( Name.last.first_name ).to eq prev_name
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
          it_should_behave_like "it logged in"
        end

        describe :bad_params do
          let(:ps) { bad_params }
          let(:ups) { user_params }
          it_should_behave_like "it did not create a user"
          it_should_behave_like "it did not save a document"
          it_should_behave_like "it did not log in"
        end

        describe :bad_user_params do
          let(:ps) { params }
          let(:ups) { bad_user_params }
          it_should_behave_like "it did not create a user"
          it_should_behave_like "it did not save a document"
          it_should_behave_like "it did not log in"
        end

        describe :revised_params do

          before :each do
            expect{ post base_path, { class_sym => bad_params, user: user_params } }.to change{ User.count }.by 0
          end

          let(:ps) { params }
          let(:ups) { user_params }
          it_should_behave_like "it created a user"
          it_should_behave_like "it saved a document"
          it_should_behave_like "it logged in"
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
        it_should_behave_like "it logged in"

        describe :incorrect_login do

          before :each do
            @bad_login_params = user_params
            @bad_login_params[:password] = "qwerqwer123!"
          end

          let(:ps) { params }
          let(:ups) { @bad_login_params }
          it_should_behave_like "it did not create a user"
          it_should_behave_like "it did not save a document"
          it_should_behave_like "it did not log in"
        end
      end

      describe :no_user_params do
        let(:ps) { params }
        let(:ups) { nil }
        it_should_behave_like "it did not create a user"
        it_should_behave_like "it did not save a document"
        it_should_behave_like "it did not log in"
      end
    end

    describe :logged_in do

      let(:ps) { params }
      let(:ups) { nil }
      let(:current_email) { user_params[:email] }
      
      before :each do
        post base_path, { class_sym => other_params, user: user_params }
        delete destroy_user_session_path
        post user_session_path, user: login_params
        get edit_user_registration_path
        expect(response).to be_success
      end

      describe :good_params do
        it_should_behave_like "it did not create a user"
        it_should_behave_like "it saved a document"
        it_should_behave_like "it logged in"
      end

      describe "good params and login for another user" do
        let(:ups) { other_user_params }
        it_should_behave_like "it did not create a user"
        it_should_behave_like "it saved a document"
        it_should_behave_like "it logged in"
      end

      describe "good params and nonsense login" do
        let(:ups) { {email: "herp@derp.twerp", password: 'asdfasdf'} }
        it_should_behave_like "it did not create a user"
        it_should_behave_like "it saved a document"
        it_should_behave_like "it logged in"
      end
    end
  end

  describe :show do

    before :each do
      post base_path, { class_sym => params, user: user_params }
      @doc = model.last
      delete destroy_user_session_path
      post base_path, { class_sym => other_params, user: other_user_params }
      @other_doc = model.last
      delete destroy_user_session_path
    end

    describe :not_logged_in do

      before :each do
        delete destroy_user_session_path
        get edit_user_registration_path
        expect(response).not_to be_success
      end

      it "should not be able to access their document" do
        expect { get show_path }.to raise_error(ActionController::RoutingError)
      end

      it "should not be able to access the other user's document" do
        expect { get other_show_path }.to raise_error(ActionController::RoutingError)
      end

    end

    describe :logged_in do

      describe :as_primary_user do
        before :each do
          delete destroy_user_session_path
          post user_session_path, user: login_params
          get edit_user_registration_path
          expect(response).to be_success
        end

        it "should be able to access their document" do
          get show_path
          expect(response).to be_success
          expect(response).to render_template :show
        end

        it "should not be able to access the other user's document" do
          expect { get other_show_path }.to raise_error(ActionController::RoutingError)
        end
      end

      describe :as_other_user do
        before :each do
          delete destroy_user_session_path
          post user_session_path, user: other_login_params
          get edit_user_registration_path
          expect(response).to be_success
        end

        it "should be able to access their document" do
          get other_show_path
          expect(response).to be_success
          expect(response).to render_template :show
        end

        it "should not be able to access the main user's document" do
          expect { get show_path }.to raise_error(ActionController::RoutingError)
        end
      end
    end

  end

  describe :update do

    let(:first_name) { "Jimmy jim jim" }
    let(:address) { "1 Infinite Loop"}

    before :each do
      post base_path, { class_sym => params, user: user_params }
      delete destroy_user_session_path
      @existing = model.last
      @last_updated = @existing.updated_at
      @path = "#{base_path}/#{@existing.id}"
      @new_params = params
      @new_params[:name_attributes][:first_name] = first_name
      @new_params[:current_address_attributes][:street_address] = address
    end

    describe :logged_in do

      describe :as_primary_user do

        before :each do
          delete destroy_user_session_path
          post user_session_path, user: login_params
        end

        describe :good_params do
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

        describe :bad_params do
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

      describe :as_other_user do

        before :each do
          delete destroy_user_session_path
          post user_session_path, user: other_login_params
        end

        it "should 404 with good params" do
          expect{ put @path, class_sym => @new_params }.to raise_error(ActionController::RoutingError)
          expect(model.last.name.first_name).not_to eq first_name
          expect(model.last.current_address.street_address).not_to eq address
        end

        it "should 404 with bad params" do
          expect{ put @path, class_sym => bad_params }.to raise_error(ActionController::RoutingError)
          expect(model.last.name.first_name).not_to eq first_name
          expect(model.last.current_address.street_address).not_to eq address
        end
      end

    end

    describe :not_logged_in do

      before :each do
        delete destroy_user_session_path
      end

      it "should 404 with good params" do
        expect{ put @path, class_sym => @new_params }.to raise_error(ActionController::RoutingError)
        expect(model.last.name.first_name).not_to eq first_name
        expect(model.last.current_address.street_address).not_to eq address
      end

      it "should 404 with bad params" do
        expect{ put @path, class_sym => bad_params }.to raise_error(ActionController::RoutingError)
        expect(model.last.name.first_name).not_to eq first_name
        expect(model.last.current_address.street_address).not_to eq address
      end
    end

  end

end
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

  describe :create do

    describe :html do

      describe :not_logged_in do

        describe :new_user do

          describe :good_params do
            it "should create a user" do
              expect{ post base_path, { class_sym => params, user: user_params } }.to change{ User.count }.by 1
            end
            it "should save" do
              expect{ post base_path, { class_sym => params, user: user_params } }.to change{ model.count }.by 1
              expect(model.last.name.first_name).to eq params[:name_attributes][:first_name]
              expect(response).to redirect_to(model.last)
            end
            it "should save two addresses" do
              expect{ post base_path, { class_sym => params, user: user_params } }.to change{ Address.count }.by 2
            end
            it "should save one name" do
              expect{ post base_path, { class_sym => params, user: user_params } }.to change{ Name.count }.by 1
            end
          end

          describe :bad_params do
            it "should create a user" do
              expect{ post base_path, { class_sym => bad_params, user: user_params } }.to change{ User.count }.by 1
            end
            it "should not save" do
              expect{ post base_path, { class_sym => bad_params, user: user_params } }.to change{ model.count }.by 0
              expect(model.last.name.first_name).not_to eq params[:name_attributes][:first_name]
              expect(response).to be_success
              expect(response).to render_template :new
            end
            it "should save zero addresses" do
              expect{ post base_path, { class_sym => bad_params, user: user_params } }.to change{ Address.count }.by 0
            end
            it "should save zero names" do
              expect{ post base_path, { class_sym => bad_params, user: user_params } }.to change{ Name.count }.by 0
            end
          end

          describe :bad_user_params do
            it "should not create a user" do
              expect{ post base_path, { class_sym => params, user: bad_user_params } }.to change{ User.count }.by 0
            end
            it "should not save" do
              expect{ post base_path, { class_sym => params, user: bad_user_params } }.to change{ model.count }.by 0
              expect(model.last.name.first_name).not_to eq params[:name_attributes][:first_name]
              expect(response).to be_success
              expect(response).to render_template :new
            end
            it "should save zero addresses" do
              expect{ post base_path, { class_sym => params, user: bad_user_params } }.to change{ Address.count }.by 0
            end
            it "should save zero names" do
              expect{ post base_path, { class_sym => params, user: bad_user_params } }.to change{ Name.count }.by 0
            end
          end

          describe :revised_params do

            before :each do
              expect{ post base_path, { class_sym => bad_params, user: user_params } }.to change{ User.count }.by 1
            end

            it "should not create a user" do
              expect{ post base_path, class_sym => params }.to change{ User.count }.by 0
            end
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
        end

        describe :existing_user do

          before :each do
            @user = User.new(user_params)
            @user.save!
          end

          describe :correct_login do
            it "should not create a user" do
              expect{ post base_path, { class_sym => params, user: user_params } }.to change{ User.count }.by 0
            end
            it "should save" do
              expect{ post base_path, { class_sym => params, user: user_params } }.to change{ model.count }.by 1
              expect(model.last.name.first_name).to eq params[:name_attributes][:first_name]
              expect(response).to redirect_to(model.last)
            end
            it "should save two addresses" do
              expect{ post base_path, { class_sym => params, user: user_params } }.to change{ Address.count }.by 2
            end
            it "should save one name" do
              expect{ post base_path, { class_sym => params, user: user_params } }.to change{ Name.count }.by 1
            end
          end

          describe :incorrect_login do

            before :each do
              bad_login_params = user_params
              bad_login_params[:password] = "qwerqwer123!"
            end
            it "should not create a user" do
              expect{ post base_path, { class_sym => params, user: bad_user_params } }.to change{ User.count }.by 0
            end
            it "should not save" do
              expect{ post base_path, { class_sym => params, user: bad_user_params } }.to change{ model.count }.by 0
              expect(model.last.name.first_name).not_to eq params[:name_attributes][:first_name]
              expect(response).to be_success
              expect(response).to render_template :new
            end
            it "should save zero addresses" do
              expect{ post base_path, { class_sym => params, user: bad_user_params } }.to change{ Address.count }.by 0
            end
            it "should save zero names" do
              expect{ post base_path, { class_sym => params, user: bad_user_params } }.to change{ Name.count }.by 0
            end
          end
        end

        describe :no_user_params do

          it "should not create a user" do
            expect{ post base_path, class_sym => params }.to change{ User.count }.by 0
          end

          it "should not save" do
            expect{ post base_path, class_sym => params }.to change{ model.count }.by 0
            expect(response).to be_success
            expect(response).to render_template :new
          end

          it "should save zero addresses" do
            expect{ post base_path, class_sym => params }.to change{ Address.count }.by 0
          end

          it "should save zero names" do
            expect{ post base_path, class_sym => params }.to change{ Name.count }.by 0
          end
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
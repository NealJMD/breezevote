describe Name do

  let ( :name ) { create :name }

  subject { name }
  
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:middle_name) }
  it { should respond_to(:middle_initial) }
  it { should respond_to(:suffix) }

  it { should be_valid }

  [[nil, 'nil'], ["", 'empty string'], ["  ", 'space string']].each do |blank, blank_written|
    
    [:first_name, :last_name].each do |field|
      it "should be valid with #{blank_written} for #{field}" do
        name[field] = blank
        expect(name).to be_invalid
      end
    end

    [:middle_name, :suffix].each do |field|
      it "should be valid with #{blank_written} for #{field}" do
        name[field] = blank
        expect(name).to be_valid
      end
    end

    describe :middle_initial do
      it "#{blank_written} middle name should return empty string for middle initial" do
        name[:middle_name] = blank
        expect( name.middle_initial ).to eq ""
      end
    end
  end

  [:first_name, :last_name, :middle_name].each do |field|
    it "should be invalid with 61 character name" do
      name[field] = "Ponce de Leon Rodriquez Santa Maria de la Virgen de la Ladron"
      expect(name).to be_invalid
    end
  end

  it "should reject suffix of more than 10 characters" do
    name.suffix = "Much too long"
    expect(name).to be_invalid
  end

end
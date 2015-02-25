describe Name do

  let ( :name ) { create :name }

  subject { name }
  
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:middle_name) }
  it { should respond_to(:middle_initial) }
  it { should respond_to(:suffix) }

  it { should be_valid }

  [[nil, 'nil'], ["", 'empty string']].each do |blank, blank_written|
    
    [:first_name, :last_name].each do |field|
      it "#{blank_written} for #{field} should be invalid" do
        name[field] = blank
        expect(name).to be_invalid
      end
    end

    [:middle_name, :suffix].each do |field|
      it "#{blank_written} for #{field} should be valid" do
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

  [:first_name, :last_name, :middle_name, :suffix].each do |field|
    it "all whitespace for #{field} should be invalid" do
      name[field] = "      "
      expect(name).to be_invalid
    end
  end

end
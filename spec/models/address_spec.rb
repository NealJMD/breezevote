describe Address do

  let ( :address ) { create :address }

  subject { address }
  
  it { should respond_to(:street_address) }
  it { should respond_to(:apartment) }
  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:country) }
  it { should respond_to(:zip) }

  it { should be_valid }

  [[nil, 'nil'], ["", 'empty string']].each do |blank, blank_written|
    
    [:street_address, :city, :state, :country].each do |field|
      it "#{blank_written} for #{field} should be invalid" do
        address[field] = blank
        expect(address).to be_invalid
      end
    end

    [:apartment, :zip].each do |field|
      it "#{blank_written} for #{field} should be valid" do
        address[field] = blank
        expect(address).to be_valid
      end
    end
  end

  [:street_address, :city, :state, :country, :apartment, :zip].each do |field|

    it "should be invalid with a #{field} of over 100 characters" do
      address[field] = "Del colegio Verde Sonrisa - una cuadra arriba, una al sur, la casa amarilla en la esquina, numero 166"
      expect(address).to be_invalid
    end
  end

  describe :state do
    it "should be invalid with a not real state" do
      address.state = "Nicaragua"
      expect(address).to be_invalid
    end

    it "should be invalid with a not real state code" do
      address.state = "AB"
      expect(address).to be_invalid
    end

    it "should be valid with a real state code" do
      address.state = "MA"
      expect(address).to be_valid
      expect(address.state).to eq "MA"
    end

    it "should be valid with a real state name" do
      address.state = "California"
      expect(address).to be_valid
      expect(address.state).to eq "CA"
    end

    it "should have the state code instead of name after save" do
      address.state = "Virginia"
      address.save!
      expect(address.state).to eq "VA"
    end

    it "should have DC instead of name after save with bad formatting" do
      address.state = "district of columbia "
      address.save!
      expect(address.state).to eq "DC"
    end

    it "should have PR instead of name after save with bad formatting" do
      address.state = "pueRTo rico"
      address.save!
      expect(address.state).to eq "PR"
    end
  end

  describe :country do

    ["U.S.", "united states ", "aMERica"].each do |corruption|
      it "should conform #{corruption} to USA" do
        address.country = corruption
        address.save!
        expect(address.country).to eq "USA"
        expect(address.is_abroad?).to eq false
      end
    end

    it "should not conform another country to USA" do
      address.country = "Nicaragua"
      address.save!
      expect(address.country).to eq "Nicaragua"
      expect(address.is_abroad?).to eq true
    end

    it "should not conform blank to USA" do
      address.country = "  "
      saved = address.save
      expect(address.country).not_to eq "USA"
      expect(saved).to be false
    end
  end

end

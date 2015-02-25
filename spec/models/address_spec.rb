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

end

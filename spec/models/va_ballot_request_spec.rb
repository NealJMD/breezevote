describe VaBallotRequest do

  it_behaves_like "addressable", VaBallotRequest, :va_ballot_request

  let (:request) { create :va_ballot_request }

  subject { request }

  it { should be_valid }


  describe :reason_code do

    it "should not accept nil" do
      request[:reason_code] = nil
      expect(request).to be_invalid
    end

    it "should not accept blank" do
      request[:reason_code] = ""
      expect(request).to be_invalid
    end

    it "should not accept an unlisted code" do
      request[:reason_code] = "8E"
      expect(request).to be_invalid
    end

    it "should accept a listed code" do
      request[:reason_code] = "2B"
      expect(request).to be_valid
    end

  end



  describe :ssn_four do

    it "should not accept nil" do
      request[:ssn_four] = nil
      expect(request).to be_invalid
    end

    it "should not accept blank" do
      request[:ssn_four] = "    "
      expect(request).to be_invalid
    end

    it "should not accept 3 digits" do
      request[:ssn_four] = "123"
      expect(request).to be_invalid
    end

    it "should not accept 5 digits" do
      request[:ssn_four] = "12345"
      expect(request).to be_invalid
    end

    it "should not accept any letters" do
      request[:ssn_four] = "12A5"
      expect(request).to be_invalid
    end

    it "should not accept any blanks" do
      request[:ssn_four] = "12 5"
      expect(request).to be_invalid
    end

    it "should not accept any punctuation" do
      request[:ssn_four] = "3-15"
      expect(request).to be_invalid
    end

    it "should not accept all letters" do
      request[:ssn_four] = "asdf"
      expect(request).to be_invalid
    end

    it "should accept 4 digit string" do
      request[:ssn_four] = "0123"
      expect(request).to be_valid
    end

    it "should accept 4 digit number" do
      request[:ssn_four] = 1234
      expect(request).to be_valid
    end
  end


end
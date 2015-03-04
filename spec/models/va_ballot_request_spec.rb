describe VaBallotRequest do

  it_behaves_like "addressable", VaBallotRequest, :va_ballot_request
  it_behaves_like "has ssn_four", :va_ballot_request, false

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

end
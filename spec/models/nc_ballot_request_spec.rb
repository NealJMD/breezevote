describe NcBallotRequest do

  it_behaves_like "addressable", NcBallotRequest, :nc_ballot_request
  it_behaves_like "has ssn_four", :nc_ballot_request, true

  let (:request) { create :nc_ballot_request }

  subject { request }

  it { should be_valid }

  describe :moved_recently do

    it "should reject when moved recently but no date" do
      request.moved_recently = true
      request.date_moved = nil
      expect(request).to be_invalid
    end

    it "should accept when moved recently and has date" do
      request.moved_recently = true
      request.date_moved = 25.days.ago.to_date
      expect(request).to be_valid
    end

    it "should accept when not moved recently and no date" do
      request.moved_recently = false
      request.date_moved = nil
      expect(request).to be_valid
    end
  end

  describe :birthdate do

    it "should reject when birthdate is blank" do
      request.birthdate = nil
      expect(request).to be_invalid
    end

    it "should reject when birthdate is not a date" do
      request.birthdate = "a while back"
      expect(request).to be_invalid
    end
  end

end
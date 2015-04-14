describe Submission do

  let (:acceptable) { [:va_ballot_request, :nc_ballot_request] }
  let (:quantity) { 12 }
  let (:base_docs) { acceptable.map { |s| create s } }
  let (:documents) { (1..quantity).map { |i| create acceptable.sample } }
  let (:users) { create_list :user, 3 }
  # let (:other_user) { create :user }

  before :each do
    DatabaseCleaner.clean # we test for id collisions, so this is key
    @b = base_docs
    @s = Submission.new(document: documents[0], user: users[0])
    @s.save!
  end

  describe :validations do

    it "should be valid" do
      expect(@s).to be_valid
    end

    it "should require document" do
      @s.document = nil
      expect(@s).to be_invalid
    end

    it "should require user" do
      @s.user = nil
      expect(@s).to be_invalid
    end

  end


  describe :submissions do

    it 'should be able to create a submission that belongs to the user' do
      expect(@s).to be_persisted
      expect(Submission.last.user_id).to eq users[0].id
      expect(@s.user.id).to eq users[0].id
    end

    it 'should be able to retrieve the submission from the user' do
      expect(users[0].submissions.last).to eq @s
    end

    it 'should be able to retrieve the submission from the document' do
      expect(documents[0].submission).to eq @s
    end

    it 'should be able to retrieve the user from the document' do
      expect(documents[0].user).to eq users[0]
    end

    describe :multiple_bindings do

      it 'should be able to give multiple documents to a user' do
        @s2 = Submission.new(document: documents[1], user: users[0])
        @s2.save
        expect(users[0].submissions.map(&:document)).to match_array([documents[0], documents[1]])
      end

      it 'should not be able to give multiple users to a document' do
        @s2 = Submission.new(document: documents[0], user: users[1])
        expect(@s2).to be_invalid
        expect(@s2.save).to eq false
        expect(documents[0].user).to eq users[0]
      end

      it "should be able to bind to two different document types with the same ID" do
        expect(@b[0].id).to eq @b[1].id
        expect(@b[0].symbol).not_to eq @b[1]
        sx = Submission.new(document: @b[0], user: users[0])
        sy = Submission.new(document: @b[1], user: users[1])
        expect(sx).to be_valid
        expect(sy).to be_valid
        expect(sx.save).to be true
        expect(sy.save).to be true
      end

    end
  end

end
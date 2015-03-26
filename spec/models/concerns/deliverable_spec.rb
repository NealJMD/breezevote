describe Deliverable do

  before :each do
    acceptable = [:nc_ballot_request, :va_ballot_request]
    @doc = create acceptable.sample
  end

  describe :status do

    it 'should default to unknown status' do
      expect(@doc.unknown?).to eq true
    end

    it 'should map string to delivery_requested' do
      @doc.status = 'delivery_requested'
      expect(@doc.delivery_requested?).to eq true
      expect(@doc.client_handle?).to eq false
      expect(@doc.delivered?).to eq false
      expect(@doc.voted?).to eq false
    end

    it 'should map string to client_handle' do
      @doc.status = 'client_handle'
      expect(@doc.delivery_requested?).to eq false
      expect(@doc.client_handle?).to eq true
      expect(@doc.delivered?).to eq false
      expect(@doc.voted?).to eq false
    end

    it 'should map string to delivered' do
      @doc.status = 'delivered'
      expect(@doc.delivery_requested?).to eq false
      expect(@doc.client_handle?).to eq false
      expect(@doc.delivered?).to eq true
      expect(@doc.voted?).to eq false
    end

    it 'should map string to voted' do
      @doc.status = 'voted'
      expect(@doc.delivery_requested?).to eq false
      expect(@doc.client_handle?).to eq false
      expect(@doc.delivered?).to eq false
      expect(@doc.voted?).to eq true
    end

  end
end

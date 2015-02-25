class ChangeSsnFourTypeInVaBallotRequest < ActiveRecord::Migration
  def up
    change_column :va_ballot_requests, :ssn_four, :string
  end

  def down
    change_column :va_ballot_requests, :ssn_four, :integer
  end
end

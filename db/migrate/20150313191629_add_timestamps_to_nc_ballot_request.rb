class AddTimestampsToNcBallotRequest < ActiveRecord::Migration
  def change
    change_table(:nc_ballot_requests) { |t| t.timestamps }
  end
end

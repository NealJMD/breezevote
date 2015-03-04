class CreateNcBallotRequest < ActiveRecord::Migration
  def change
    create_table :nc_ballot_requests do |t|
      t.references :name
      t.integer    :current_address_id, index: true
      t.integer    :registered_address_id, index: true
      t.string     :ssn_four
      t.string     :license_number
      t.date       :birthdate

      t.boolean    :moved_recently
      t.date       :date_moved
    end
  end
end

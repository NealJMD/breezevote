class CreateVaBallotRequests < ActiveRecord::Migration
  def change
    create_table :va_ballot_requests do |t|
      t.references :name, index: true
      t.integer :current_address_id, index: true
      t.integer :registered_address_id, index: true
      t.integer :ssn_four
      t.string :reason_code
      t.string :reason_support

      t.timestamps
    end
  end
end

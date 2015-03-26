class AddStatusToDocuments < ActiveRecord::Migration
  def change
    add_column :va_ballot_requests, :status, :integer, default: 0, null: false
    add_column :nc_ballot_requests, :status, :integer, default: 0, null: false
  end
end

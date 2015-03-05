class ChangeMovedRecentlyDefault < ActiveRecord::Migration
  def up
    change_column :nc_ballot_requests, :moved_recently, :boolean, :default => false
  end

  def down
    change_column :nc_ballot_requests, :moved_recently, :boolean, :default => nil
  end
end

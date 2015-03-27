class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.belongs_to :user, index: true
      t.integer :document_id
      t.string  :document_type
      t.timestamps
    end

    add_index :submissions, :document_id
  end
end

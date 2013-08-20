class CreateDuplicates < ActiveRecord::Migration
  def change
    create_table :duplicates do |t|
      t.integer :nugget_id
      t.integer :duplicate_nugget_id
      t.integer :user_id
      t.string  :duplicate_status
      t.timestamps
    end
  end
end

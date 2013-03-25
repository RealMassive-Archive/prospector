class CreateNuggetSignages < ActiveRecord::Migration
  def change
    create_table :nugget_signages do |t|
      t.integer :nugget_id

      t.timestamps
    end
  end
end

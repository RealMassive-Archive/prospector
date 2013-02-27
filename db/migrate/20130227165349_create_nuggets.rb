class CreateNuggets < ActiveRecord::Migration
  def change
    create_table :nuggets do |t|
      t.string :state
      t.decimal :latitude
      t.decimal :longitude
      t.string :submitter
      t.string :submission_method
      t.datetime :submission_on

      t.timestamps
    end
  end
end

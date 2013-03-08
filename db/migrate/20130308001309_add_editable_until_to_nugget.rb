class AddEditableUntilToNugget < ActiveRecord::Migration
  def change
    add_column :nuggets, :editable_until, :datetime
  end
end

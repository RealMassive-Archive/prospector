class AddSignage2ToNuggetSignages < ActiveRecord::Migration
  def change
    add_column :nugget_signages, :signage2, :string
  end
end

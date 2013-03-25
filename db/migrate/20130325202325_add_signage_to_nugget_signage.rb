class AddSignageToNuggetSignage < ActiveRecord::Migration
  def change
    add_column :nugget_signages, :signage, :string
  end
end

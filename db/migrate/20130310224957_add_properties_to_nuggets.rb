class AddPropertiesToNuggets < ActiveRecord::Migration
  def change
    add_column :nuggets, :signage_phone, :string
    add_column :nuggets, :signage_listing_type, :string
  end
end

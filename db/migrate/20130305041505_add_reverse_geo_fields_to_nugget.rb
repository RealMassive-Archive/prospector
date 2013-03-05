class AddReverseGeoFieldsToNugget < ActiveRecord::Migration
  def change
    add_column :nuggets, :signage_address, :string
    add_column :nuggets, :signage_city, :string
    add_column :nuggets, :signage_state, :string
    add_column :nuggets, :signage_county, :string
    add_column :nuggets, :signage_neighborhood, :string
  end
end

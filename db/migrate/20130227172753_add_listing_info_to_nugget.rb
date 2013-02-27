class AddListingInfoToNugget < ActiveRecord::Migration
  def change
    add_column :nuggets, :approx_address, :string
    add_column :nuggets, :nugget_type, :string
    add_column :nuggets, :nugget_phone, :string
  end
end

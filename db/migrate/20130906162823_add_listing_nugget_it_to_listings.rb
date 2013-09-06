class AddListingNuggetItToListings < ActiveRecord::Migration
  def change
    add_column :listings, :listing_nugget_id, :integer
  end
end

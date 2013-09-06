class AddListingExtractedToListingNuggets < ActiveRecord::Migration
  def change
    add_column :listing_nuggets, :listing_extracted, :boolean, :default=> false
  end
end

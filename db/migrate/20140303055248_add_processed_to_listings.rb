class AddProcessedToListings < ActiveRecord::Migration
  def change
    add_column :listings, :processed, :boolean, default: false
    add_index  :listings, :processed
  end
end

class AddSignageIntersectionToNugget < ActiveRecord::Migration
  def change
     add_column :nuggets, :signage_intersection, :string
  end
end

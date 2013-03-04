class AddSignageToNugget < ActiveRecord::Migration
  def change
    add_column :nuggets, :signage, :string
  end
end

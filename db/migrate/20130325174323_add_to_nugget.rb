class AddToNugget < ActiveRecord::Migration
  def change
    add_column :nuggets, :is_new_multisignage_nugget, :boolean
  end
end

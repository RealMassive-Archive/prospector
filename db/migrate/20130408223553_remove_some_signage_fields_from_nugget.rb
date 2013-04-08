class RemoveSomeSignageFieldsFromNugget < ActiveRecord::Migration
  def up
    remove_column :nuggets, :signage
    remove_column :nuggets, :is_new_multisignage_nugget
  end

  def down
    add_column :nuggets, :signage, :string
    add_column :nuggets, :is_new_multisignage_nugget, :boolean
  end
end

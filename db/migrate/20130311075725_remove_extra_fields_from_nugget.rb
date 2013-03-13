class RemoveExtraFieldsFromNugget < ActiveRecord::Migration
  def change
    remove_column :nuggets, :approx_address
    remove_column :nuggets, :nugget_type
    remove_column :nuggets, :nugget_phone
  end
end

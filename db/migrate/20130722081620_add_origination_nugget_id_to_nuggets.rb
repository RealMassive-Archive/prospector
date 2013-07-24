class AddOriginationNuggetIdToNuggets < ActiveRecord::Migration
  def change
    add_column :nuggets, :origination_nugget_id, :integer
  end
end

class AddOriginationEmailIdToNuggets < ActiveRecord::Migration
  def change
    add_column :nuggets, :origination_email_id, :integer
  end
end

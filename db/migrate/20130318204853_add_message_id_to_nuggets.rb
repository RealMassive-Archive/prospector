class AddMessageIdToNuggets < ActiveRecord::Migration
  def change
    # message_id is the id of the original email the nugget came in from
    add_column :nuggets, :message_id, :string
  end
end

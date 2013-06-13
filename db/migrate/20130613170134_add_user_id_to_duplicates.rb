class AddUserIdToDuplicates < ActiveRecord::Migration
  def change
    add_column :duplicates, :user_id, :integer
  end
end

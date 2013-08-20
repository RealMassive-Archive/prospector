class RenameDuplicateNuggetIdToComparedToNuggetId < ActiveRecord::Migration
  def up
    rename_column :duplicates, :duplicate_nugget_id, :compared_to_nugget_id
  end

  def down
  end
end

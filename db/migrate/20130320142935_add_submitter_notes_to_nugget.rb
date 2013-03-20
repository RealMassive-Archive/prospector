class AddSubmitterNotesToNugget < ActiveRecord::Migration
  def change
    add_column :nuggets, :submitter_notes, :string
  end
end

class CreateNuggetStateTransitions < ActiveRecord::Migration
  def change
    create_table :nugget_state_transitions do |t|
      t.references :nugget
      t.string :event
      t.string :from
      t.string :to
      t.timestamp :created_at
    end
    add_index :nugget_state_transitions, :nugget_id
  end
end

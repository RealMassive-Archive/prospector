class AddStateMessageToNuggetStateTransition < ActiveRecord::Migration
  def change
    add_column :nugget_state_transitions, :state_message, :string
  end
end

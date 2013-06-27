class CreateBrokerCalls < ActiveRecord::Migration
  def change
    create_table :broker_calls do |t|
      t.integer :caller_id
      t.integer :nugget_id
      t.string  :call_result
      t.string  :call_comments
      t.string  :broker_name
      t.string  :broker_email

      t.timestamps
    end
  end
end

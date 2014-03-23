class CreateApiRequests < ActiveRecord::Migration
  def change
    create_table :api_requests do |t|
      t.string        :model_type
      t.text          :request_body
      t.text          :response_body
      t.integer       :response_code
      t.string        :status
      t.string        :run_method
      t.timestamps
    end

    add_index :api_requests, :model_type
    add_index :api_requests, :status
    add_index :api_requests, :created_at
    add_index :api_requests, :updated_at
  end
end

class CreateApiRequests < ActiveRecord::Migration
  def change
    create_table :api_requests do |t|
      t.string        :model_type
      t.text          :request_options
      t.text          :response_body
      t.integer       :response_code
      t.string        :status
      t.string        :run_method
      t.text          :run_args_hash # store this as json if possible
      t.string        :request_url # where the request originally went
      t.timestamps
    end

    add_index :api_requests, :model_type
    add_index :api_requests, :status
    add_index :api_requests, :created_at
    add_index :api_requests, :updated_at
  end
end

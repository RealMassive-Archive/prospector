class CreateListingChecks < ActiveRecord::Migration
  def change
    create_table :listing_checks do |t|
      t.string        :real_estate_type
      t.string        :check_status
      t.text          :request_payload
      t.text          :response_payload
      t.timestamps
    end
  end
end

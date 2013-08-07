class CreateListingNuggets < ActiveRecord::Migration
  def change
    create_table :listing_nuggets do |t|
      t.integer :broker_email_id
      t.string  :broker_email_to
      t.string  :broker_email_from
      t.string  :broker_email_subject
      t.text    :broker_email_body
      t.timestamps
    end
  end
end

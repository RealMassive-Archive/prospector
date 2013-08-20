class CreateTableBrokerEmailAttachmentsListingNuggets < ActiveRecord::Migration
  def up
    create_table :broker_email_attachments_listing_nuggets, id: false do |t|
      t.integer :broker_email_attachment_id
      t.integer :listing_nugget_id
    end
  end

  def down
    drop_table :broker_email_attachments_listing_nuggets
  end
end

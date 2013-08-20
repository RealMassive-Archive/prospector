class CreateBrokerEmailAttachments < ActiveRecord::Migration
  def change
    create_table :broker_email_attachments do |t|
      t.integer :broker_email_id
      t.string  :file
      t.timestamps
    end
  end
end

class AddParsedToBrokerEmails < ActiveRecord::Migration
  def change
    add_column :broker_emails, :parsed, :boolean, :default => false
  end
end

class AddEmailFieldsToNugget < ActiveRecord::Migration
  def change
    add_column :nuggets, :broker_email_to, :string
    add_column :nuggets, :broker_email_from, :string
    add_column :nuggets, :broker_email_subject, :string
    add_column :nuggets, :broker_email_body, :text
  end
end

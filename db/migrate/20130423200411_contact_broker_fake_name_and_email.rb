class ContactBrokerFakeNameAndEmail < ActiveRecord::Migration
  def change
    add_column :nuggets, :contact_broker_fake_name, :string
    add_column :nuggets, :contact_broker_fake_email, :string
  end
end

class SetDefaultValueOfSpamInBrokerEmails < ActiveRecord::Migration
  def up
    #postgres do not support change_column migration, so this is a fix to set default value of spam field
    remove_column :broker_emails, :spam
    remove_column :broker_emails, :need_supervisor_review
    add_column :broker_emails, :spam, :boolean, :default => false
    add_column :broker_emails, :need_supervisor_review, :boolean, :default => false
  end

  def down
  end
end

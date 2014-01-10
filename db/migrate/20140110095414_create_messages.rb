#
# CreateMessages
#
# Creates the "Messages" table for the "Message" class.
# Responsible for quickly storing all incoming data from
# Postmark. The goal is to shove the data - including the
# message attachments - into a big text field immediately,
# then return a quick response to the client (Postmark).
# Later, a Resque worker will come along, find the message,
# and process it accordingly.

class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text          :message_body
      t.datetime      :received_at # When the app pushed this to the DB
      t.datetime      :began_processing_at # When processing *started*
      t.datetime      :finished_processing_at # When processing *finished*
      t.datetime      :failed_at # When processing *failed* if it did. May be null.
      t.timestamps
    end
  end
end

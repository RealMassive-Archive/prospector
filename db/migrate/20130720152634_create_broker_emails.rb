class CreateBrokerEmails < ActiveRecord::Migration
  def change
    create_table :broker_emails do |t|
      t.integer   :nugget_id
      t.string    :from
      t.string    :to
      t.string    :subject
      t.text      :body
      t.boolean   :spam
      t.boolean   :need_supervisor_review
      t.string    :review_reason

      t.timestamps
    end
  end
end
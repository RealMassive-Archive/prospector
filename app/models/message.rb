class Message < ActiveRecord::Base
  attr_accessible :message_body, :received_at

  def start_processing!
    update_attribute(:began_processing_at, Time.now.utc)
  end

  def finish_processing!
    update_attribute(:finished_processing_at, Time.now.utc)
  end

  def fail!
    update_attribute(:failed_at, Time.now.utc)
  end
end

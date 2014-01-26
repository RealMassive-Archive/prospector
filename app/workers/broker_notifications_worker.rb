class BrokerNotificationsWorker
  @queue = :broker_notifications_queue

  def self.perform(broker_email_id)
    # Set up logging.
    logger = Rails.logger
    Resque.logger = Logger.new(STDOUT)
    Resque.logger.level = Logger::DEBUG
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActionMailer::Base.logger = Logger.new(STDOUT)

    # This will have to both notify the broker AND destroy the record.
    be = BrokerEmail.find(broker_email_id)
    BrokerNotificationsMailer.submission_rejected(be).deliver
    be.destroy
  end

end
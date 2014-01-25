class BrokerNotificationsWorker
  @queue = :broker_notifications_queue

  def self.perform(broker_email_id)
    # Set up logging.
    logger = Rails.logger
    Resque.logger = Logger.new(STDOUT)
    Resque.logger.level = Logger::DEBUG
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    ActionMailer::Base.logger = Logger.new(STDOUT)

    BrokerNotificationsMailer.submission_rejected(BrokerEmail.find(broker_email_id)).deliver
  end

end
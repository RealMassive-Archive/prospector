require 'logger'

class ApiRequestWorker
  # This class is a Resque worker that will look for existing ListingCheck
  # objects with the status of "new", mark them as "pending", perform the
  # API request, log the REQUEST payload, wait for a response, and then log
  # the RESPONSE payload. After completion, it will mark the status of the
  # object as "done".

  @queue = :api_request_queue

  def self.perform(id)
    # Log to STDOUT. It's a Heroku thing.
    logger = Rails.logger
    Resque.logger = Logger.new(STDOUT)
    Resque.logger.level = Logger::DEBUG
    ActiveRecord::Base.logger = Logger.new(STDOUT)

    ar = ApiRequest.find(id)
    ar.process!

    # Failsafe - look for any other object marked "new/pending" and run it.
    ApiRequest.where("status IN ('pending','new')").limit(10).each do |ar|
      ar.process!
    end


  end

end

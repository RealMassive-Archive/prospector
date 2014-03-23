require 'logger'

class ApiRequestWorker
  # This class is a Resque worker that will look for existing ListingCheck
  # objects with the status of "new", mark them as "pending", perform the
  # API request, log the REQUEST payload, wait for a response, and then log
  # the RESPONSE payload. After completion, it will mark the status of the
  # object as "done".

  @queue = :api_request_queue

  def self.perform



  end

end

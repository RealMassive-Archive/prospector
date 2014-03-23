require 'logger'

class ApiRequestWorker
  # This class is a Resque worker that will look for existing ListingCheck
  # objects with the status of "new", mark them as "pending", perform the
  # API request, log the REQUEST payload, wait for a response, and then log
  # the RESPONSE payload. After completion, it will mark the status of the
  # object as "done".

  @queue = :api_request_queue

  def self.perform
    # Fetch the first object that is "new", mark it as "pending". Do this
    # as one atomic transaction at the database layer.
    ApiRequest.transaction do
      begin
        lc = ApiRequest.where(status: "new").order_by("created at ASC").first
        lc.pending!
      rescue ActiveRecord::RecordNotFound
        # no-op, ignore it in the odd event it blows up
      end
    end

    # log the request payload and initiate a request to the API


  end

end

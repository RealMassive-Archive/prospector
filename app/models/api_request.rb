class ApiRequest < ActiveRecord::Base

  before_save :encode_args_hash
  before_create :set_status_pending

  def process!
    # Mark this object's status as "pending" to start the process
    update_attribute(:status, "pending")

    # initiate query on the model, which talks to the API. The returned response
    # object will be a Typhoeus response object which contains the original
    # request parameters that we can log.

    # The "model_type" field is the model we want to query, but don't do a
    # direct "send" here since that's just asking for trouble. Case it to be
    # safe.
    if model_type.downcase == "building"
      klass = Building
    elsif model_type.downcase == "space"
      klass = Space
    else
      update_attribute(:status, "invalid") # not modifying space/building! Mark
                                           # it as invalid so we don't have an
                                           # infinite loop later.

      return false # bail out of this method because this isn't sane
    end

    # Now do the same check for the existence of the method on the model,
    # but be sure that it's in the pre-defined list of allowed methods.
    if klass.allowed_queries && klass.allowed_queries.include?(run_method.to_sym)
      begin
        # It's inside the given whitelist, run the method
        response = klass.send(run_method.to_sym, method_args)
      rescue ArgumentError => e
        # This application threw an error before talking to the API. Mark
        # the request as failed and log.
        logger.fatal e
        update_attributes(
          response_code: 400,
          status:        "fail",
          response_body: Yajl::Encoder.encode(
            {status: "error", message: "ArgumentError: #{e}"}
          )
        )
        return false
      end


      # Look at the response code. If anything other than 200, it failed.
      request_status = response.code == 200 ? "success" : "fail"

      # Look at response object, log the request data and the response data.
      update_attributes(
        request_options: Yajl::Encoder.encode(response.request.options),
        request_url:     response.request.url, # original URL it went to
        response_code:   response.code, # what was the response code?
        response_body:   response.body, # should just be a pile of JSON already
        status:          request_status # success or fail? Either way it's done
      )
    end
  end

  # This method automatically decodes the JSON hash in run_args_hash and
  # returns the value as a real hash using Yajl.
  def method_args
    hsh = run_args_hash
    unless hsh.blank?
      return Yajl::Parser.parse(hsh)
    end
    return {} # empty hash as a sanity return
  end

private

  # Private method to automatically JSON encode the run args hash.
  # Remember to decode the JSON into a real hash prior to sending to
  # a method. This is an admitted hack/workaround where PostgreSQL hstore
  # would be a far better choice. But, you know how it goes - time. Time, time,
  # time. Never enough time.
  def encode_args_hash
    if self.run_args_hash && self.run_args_hash.is_a?(Hash)
      self.run_args_hash = Yajl::Encoder.encode(self.run_args_hash)
    end
  end

  def set_status_pending
    self.status = "pending"
  end

end

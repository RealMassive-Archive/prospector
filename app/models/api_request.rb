class ApiRequest < ActiveRecord::Base

  def process!
    # Mark this object's status as "pending" to start the process
    ar.update_attribute(:status, "pending")

    # initiate query on the model, which talks to the API. The returned response
    # object will be a Typhoeus response object which contains the original
    # request parameters that we can log.

    # The "model_type" field is the model we want to query, but don't do a
    # direct "send" here since that's just asking for trouble. Case it to be
    # safe.
    case model_type.downcase
    when "building"
      klass = Building
    when "space"
      klass = Space
    else
      return false
    end

  end

end

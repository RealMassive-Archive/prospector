class Api::BrokerEmailsController < ApplicationController
  def create
    # make sure the thing posting has rights to post here... maybe with
    # http basic auth or a super secret token.

    #n = Nugget.create_from_postmark(Postmark::Mitt.new(request.body.read))
    message= Postmark::Mitt.new(request.body.read)
    # ignore messages with no attachments
    if message.attachments.empty?
      logger.info "message #{message.message_id} from #{message.from}: no attachments!; skipping."
      # great place to send an email alerting submitter of same
      return render :nothing => true
    end
    render :nothing => true
  end
end
class Api::BrokerEmailsController < ApplicationController
  def create
    # make sure the thing posting has rights to post here... maybe with
    # http basic auth or a super secret token.

    #n = Nugget.create_from_postmark(Postmark::Mitt.new(request.body.read))
    message = Postmark::Mitt.new(request.body.read)
    # ignore messages with no attachments
    if message.from == "support@postmarkapp.com"
      logger.info "message #{message.message_id} from #{message.from}: no attachments! or support message; skipping."
      #logger.info "#{message.to_json}"
      # great place to send an email alerting submitter of same
      return render :nothing => true
    end

    if Rails.env.development?
      nugget = Nugget.awaiting_broker_response.last #only when testing (find the last nugget for the parse info from broker email jobs instead of finding it on the basis of message.to)
    else
      nugget = Nugget.find_by_contact_broker_fake_email(message.to)
    end

    logger.info("Email received with #{message.attachments.count} attachments")
    if nugget #&& !message.attachments.empty?
      broker_email = nugget.broker_emails.create(
          :from =>  message.from,
          :to   =>  nugget.contact_broker_fake_email,
          :subject => message.subject,
          :body =>  message.text_body
      )
      message.attachments.each_with_index { |attachment, i|
        begin
          broker_email_attachment = BrokerEmailAttachmentUploader.new
          broker_email_attachment.cache!(attachment.read)
          BrokerEmailAttachment.create(
              :file => broker_email_attachment,
              :broker_email_id=>broker_email.id
          )
        rescue CarrierWave::IntegrityError => e
          # puts there was a problem storing attachments
          logger.error "message #{message.message_id}: problem storing attachment #{i} ('#{attachment.file_name}') of message #{message.message_id}"
          # logger.error [e, *e.backtrace].join("\n")
          # great place to send ourselves an email warning us that some storage problem is occuring

          #return render :nothing => true
          next
        end
      }
      nugget.broker_email_received #now mark email received
      broker_email.listing_nuggets.create(
          :broker_email_from => broker_email.from,
          :broker_email_to => broker_email.to,
          :broker_email_subject => broker_email.subject,
          :broker_email_body => broker_email.body
      )
    else
      logger.info "message #{message.message_id} from #{message.from}: skipping. No nugget found with email id"
    end
    render :nothing => true
  end
end

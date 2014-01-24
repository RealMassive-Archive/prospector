class BrokerEmailWorker
  # This class exists for the same reason as nugget_worker. The
  # rationale behind why it's been generated is in there.
  # In short, the code for processing is happening in-request, and
  # needs to be pulled out into a resque worker instead.

  @queue = :broker_email_queue

  def self.perform(message_id)
binding.pry
    # logger = Rails.logger
    Resque.logger.level = Logger::DEBUG
    # Retrieve the message from the database
    db_msg = Message.find(message_id)
    db_msg.start_processing! # Tell the DB that we just started with this
    message = Postmark::Mitt.new(db_msg.message_body)

    # This check gets rid of all the postmark support emails. They're just junk.
    if message.from == 'support@postmarkapp.com'
      db_msg.destroy
      return
    end

    unless Rails.env.production?
      # Not prod, just grab the last nugget for easier testing.
      nuggets = Nugget.awaiting_broker_response
    else
      nuggets = Nugget.where(contact_broker_fake_email: message.to)
    end

    nuggets.each do |nugget|
      if nugget && !nugget.blank?
        broker_email = nugget.broker_emails.create(from: message.from, to: nugget.contact_broker_fake_email,
                       subject: message.subject, body: message.text_body)
        message.attachments.each_with_index do |attachment, i|
          begin
            broker_email_attachment = BrokerEmailAttachmentUploader.new
            broker_email_attachment.cache!(attachment.read)
            BrokerEmailAttachment.create(file: broker_email_attachment, broker_email_id: broker_email.id)
          rescue CarrierWave::IntegrityError => e
            logger.error "message #{message.message_id}: problem storing attachment #{i} ('#{attachment.file_name}') of message #{message.message_id}"
            next
          end
        end

        nugget.broker_email_received # mark email received
        broker_email.listing_nuggets.create(
            :broker_email_from => broker_email.from,
            :broker_email_to => broker_email.to,
            :broker_email_subject => broker_email.subject,
            :broker_email_body => broker_email.body
        )
      else
        # Nugget is nil or false.
        logger.info "message #{message.message_id} from #{message.from}: skipping. No nugget found with email id"
      end
    end

  end
end

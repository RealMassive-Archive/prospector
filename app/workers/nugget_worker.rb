#
# NuggetWorker
#
# January 10th 2014, J. Austin Hughey <jaustinhughey@me.com>
#
# The NuggetWorker class is used by Resque (which gets is data
# from a messages table in PostgreSQL) to do actual processing. This
# is necessary because former versions of this application were
# doing all Nugget processing - image manipulation/storage,
# API requests, sending mail, and so on - IN THE REQUEST. This
# has the obvious side effect of causing timeouts from other
# pieces of an SOA, most recently and most notably, Postmark.
# Ergo, these services re-try their API requests until they
# succeed, resulting in the generation of multiple objects
# since the timeout happens at the application routing layer
# (Heroku).
#

class NuggetWorker


  @queue = :nugget_queue

  def self.perform(message_id)
    logger = Rails.logger
    # Retrieve the message from the database
    db_msg = Message.find(message_id)
    db_msg.start_processing! # Tell the DB that we just started with this
    message = Postmark::Mitt.new(db_msg.message_body)

    # If the message has no attachments, it's not valid so kick it out and fail.
    if message.attachments.empty?
      logger.info "message #{message.message_id} from #{message.from} has no attachments. Skipping."
      SignageMailer.no_attachment(message.from, message.subject).deliver
      db_msg.finish_processing!
      return
    end

    # Special use-case handling for TogetherMobile applications.
    if message.from.include?('togethermobile.com') && message.mailbox_hash.present?
      together_hash = message.mailbox_hash.split('--together_id--')
      together_id = together_hash.last
      submitter = together_hash.first.gsub('--at--', '@')
      together_url = "https://test.togethermobile.com/export/verify.json?job_id="
      begin
        together_response = HTTParty.get(together_url + together_id)
        logger.info "from togethermobile: id=" + together_id
      rescue
        logger.info "Callback to Together Mobile failed. Error when validating to togethermobile: id=" + together_id
        db_msg.finish_processing!
        db_msg.fail!
        return
      end
    else
      submitter = message.from
    end

    # Create the nugget object itself.
    nugget = Nugget.new(submitter: submitter, submitter_notes: message.subject,
                        submission_method: "email", message_id: message.message_id,
                        submitted_at: Time.now)

    unless nugget.valid? && nugget.save
      # Nugget creation failed. Send a message to notify somebody.
      db_msg.fail!
      # TODO: Notify somebody!
    end

    # Begin processing message attachments submitted with the nugget.
    message.attachments.each_with_index do |att, i|
      begin
        signage = NuggetSignageUploader.new
        signage.cache!(att.read)
      rescue CarrierWave::IntegrityError => e
        logger.error "message #{message.message_id}: problem storing attachment #{i} ('#{att.file_name}') of message #{message.message_id}"

        # Deliver an e-mail notifying both the admin and submitter that this image couldn't be stored.
        NuggetMailer.image_store_fail(nugget).deliver
        next
      end

      # Reading data from the image itself.
      jpg = EXIFR::JPEG.new(signage.file.path)

      # Check to see if there's no GPS data, notify the submitter,
      # then fail fast.
      if jpg.gps.compact.blank?
        logger.warn "NO GPS FOUND! attachment #{i} of message_id #{message.message_id}"
        next
      else
        # Only process GPS on the first image.
        if i == 0
          nugget.latitude = jpg.gps[0]
          nugget.longitude = jpg.gps[1]
          nugget.process_geodata
          nugget.save
        end

        ns = NuggetSignage.create(nugget_id: nugget.id, signage: signage)
      end
    end

    # Check the nugget to be sure it has valid GPS data. If not, this
    # submission failed and the submitter should be notified.
    if nugget.latitude.nil?
      nugget.no_gps!
      SignageMailer.no_gps_signage_receipt(nugget, message.subject).deliver
      db_msg.fail!
      return
    else
      nugget.signage_read!
      SignageMailer.success_signage_receipt(nugget, message.subject).deliver
      db_msg.finish_processing!
      return
    end
  end
end
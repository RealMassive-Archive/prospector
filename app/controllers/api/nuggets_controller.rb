class Api::NuggetsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # POST /api/nuggets
  def create
    # make sure the thing posting has rights to post here... maybe with
    # http basic auth or a super secret token.

    #n = Nugget.create_from_postmark(Postmark::Mitt.new(request.body.read))
    message= Postmark::Mitt.new(request.body.read)
    # ignore messages with no attachments
    if message.attachments.empty?
      logger.warning "message #{message.message_id} from #{messager.from}: no attachments!; skipping."
      # great place to send an email alerting submitter of same
      return render :nothing => true
    end

    message.attachments.each_with_index { |attachment, i|
      #logger.info "message #{message.message_id}: reading attachment #{i} ('#{attachment.file_name}') of type #{attachment.content_type}"
      begin
        signage = SignageUploader.new
        signage.cache!(attachment.read)
      rescue CarrierWave::IntegrityError => e
        # puts there was a problem storing attachments
        logger.error "message #{message.message_id}: problem storing attachment #{i} ('#{attachment.file_name}') of message #{message.message_id}"
        # logger.error [e, *e.backtrace].join("\n")
        # great place to send ourselves an email warning us that some storage problem is occuring

        return render :nothing => true
      end

      n = Nugget.create!(
        submitter: message.from,
        submission_method: "email",
        submitted_at: Time.now
      )

      jpg = EXIFR::JPEG.new(signage.file.path)
      if jpg.gps.compact.blank?
        logger.warn "NO GPS FOUND!"
        n.no_gps!
        # note that when there's no GPS we don't even bother to save the file

        # send an email to submitter that there's no GPS in their upload
        SignageMailer.no_gps_signage_receipt(n, message.subject).deliver

      else
        # yay! an image with actual GPS info!
        n.latitude = jpg.gps[0]
        n.longitude = jpg.gps[1]
        n.message_id = message.message_id
        n.signage = signage
        n.process_geodata
        n.signage_read!
        # send an email to submitter that it's been received
        SignageMailer.success_signage_receipt(n, message.subject).deliver
      end

      logger.info "message #{i} of message #{message.message_id} from #{message.from}: nugget created"

    }

    render :text => "Nugget created.", :status => :created
    #render :nothing => true
  end

  private
  def clean_field(str)
    str.gsub(/\n/,'') if str
  end
end

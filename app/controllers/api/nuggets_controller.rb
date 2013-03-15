class Api::NuggetsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def create
    # make sure the thing posting has rights to post here... maybe with
    # http basic auth or a super secret token

    #n = Nugget.create_from_postmark(Postmark::Mitt.new(request.body.read))
    message= Postmark::Mitt.new(request.body.read)
    # ignore messages with no attachments
    if message.attachments.empty?
      logger.warning "message #{message.message_id} from #{messager.from}: no attachments!; skipping."
      return
    end

    message.attachments.each {|attachment, i|
      #logger.info "message #{message.message_id}: reading attachment #{i} ('#{attachment.file_name}') of type #{attachment.content_type}"
      begin
        signage = SignageUploader.new
        signage.cache!(attachment.read)
      rescue CarrierWave::IntegrityError => e
        # puts there was a problem storing attachments
        logger.error "message #{message.message_id}: problem storing attachment #{i} ('#{attachment.file_name}') of message #{message.message_id}"
        logger.error [e, *e.backtrace].join("\n")
        return
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
      else
        n.latitude = jpg.gps[0]
        n.longitude = jpg.gps[1]
        n.signage = signage
        n.process_geodata
        n.signage_read!
      end

      logger.error "message #{message.message_id} from #{message.from}: nugget created"
    }

    render :text => "Nugget created.", :status => :created
  end

  private
  def clean_field(str)
    str.gsub(/\n/,'') if str
  end
end

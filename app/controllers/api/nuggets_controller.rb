class Api::NuggetsController < ApplicationController
  skip_before_filter :verify_authenticity_token

  # GET /api/nuggets/geofind.json
  def geofind
    #austin: 30.2669, -97.7428
    latitude = params['latitude']
    longitude = params['longitude']
    distance = params['distance']
    @nuggets = Nugget.near([latitude, longitude], distance)
    render json: @nuggets
  end


  # POST /api/nuggets
  def create
    # make sure the thing posting has rights to post here... maybe with
    # http basic auth or a super secret token.

    #n = Nugget.create_from_postmark(Postmark::Mitt.new(request.body.read))
    message= Postmark::Mitt.new(request.body.read)
    # ignore messages with no attachments
    if message.attachments.empty?
      logger.info "message #{message.message_id} from #{message.from}: no attachments!; skipping."

      # Send an e-mail to the submitter telling them we don't have any attachments.
      SignageMailer.no_attachment(message.from, message.subject).deliver

      # Render a blank page with a status code of 400 (bad request)
      render :nothing => true, status: 400
    end
    logger.info "token passed in was: #{message.mailbox_hash}"
    logger.info "from #{message.from}"
    # if this came from Mike and Ben's (TogetherMobile) mobile app then use the hash for submitter
    # mail will come addressed to nugget+hash@realmassive.com
    # where hash will have   true
    if ( message.from.include?('togethermobile.com') && message.mailbox_hash.present?)
      #submitter = Base64.decode64( message.mailbox_hash )
      together_hash = message.mailbox_hash.split('--together_id--')
      together_id = together_hash.last
      submitter = together_hash.first.gsub('--at--', '@')
      together_url = "https://test.togethermobile.com/export/verify.json?job_id="
      begin
        together_response = HTTParty.get(together_url + together_id)
        logger.info "from togethermobile: id=" + together_id
      rescue
        logger.info "error when validating to togethermobile: id=" + together_id
        return render :text => "Nugget received by RealMassive, but callback to TogetherMobile failed."
      end
    else
      submitter = message.from
    end
    n = Nugget.create!(
      submitter: submitter,
      submitter_notes: message.subject,
      submission_method: "email",
      message_id: message.message_id,
      submitted_at: Time.now
    )

    message.attachments.each_with_index { |attachment, i|
      begin
        signage = NuggetSignageUploader.new
        signage.cache!(attachment.read)
      rescue CarrierWave::IntegrityError => e
        # puts there was a problem storing attachments
        logger.error "message #{message.message_id}: problem storing attachment #{i} ('#{attachment.file_name}') of message #{message.message_id}"
        # logger.error [e, *e.backtrace].join("\n")
        # great place to send ourselves an email warning us that some storage problem is occuring

        #return render :nothing => true
        next
      end

      jpg = EXIFR::JPEG.new(signage.file.path)
      if jpg.gps.compact.blank?
        logger.warn "NO GPS FOUND! attachment #{i} of message_id #{message.message_id}"
        # note that when there's no GPS we don't even bother to save the file
      else
        # yay! an image with actual GPS info!
        if i == 0  #only accept GPS info from the first attachment
          n.latitude = jpg.gps[0]
          n.longitude = jpg.gps[1]
          n.process_geodata
          n.save
        end
        ns = NuggetSignage.create(
          nugget_id: n.id,
          signage: signage
        )
        #n.nugget_signages << ns
      end
    }

    if n.latitude.nil?
      n.no_gps!
      # send an email to submitter that there was no GPS in their upload
      SignageMailer.no_gps_signage_receipt(n, message.subject).deliver
      return render :text => "No GPS Nugget created."
    else
      n.signage_read!
      # send an email to submitter that it's been received
      SignageMailer.success_signage_receipt(n, message.subject).deliver
      return render :text => "Nugget created.", :status => :created
    end

    render :nothing => true
  end

  private
  def clean_field(str)
    str.gsub(/\n/,'') if str
  end
end

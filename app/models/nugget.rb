class Nugget < ActiveRecord::Base
  mount_uploader :signage, SignageUploader

  reverse_geocoded_by :latitude, :longitude, {address: :signage_address}
  #after_validation :reverse_geocode

  attr_accessible :latitude, :longitude
  attr_accessible :submission_method, :submitted_at, :submitter
  attr_accessible :state
  attr_accessible :nugget_type, :nugget_phone, :approx_address
  attr_accessible :signage
  attr_accessible :signage_address, :signage_city, :signage_state, :signage_county, :signage_neighborhood

  validates_inclusion_of :nugget_type, :in => %w(lease sale), :allow_nil => true
  validates_inclusion_of :submission_method, :in => %w(email sms), :allow_nil => true

  before_save :default_values

  default_scope order(:submitted_at)
  scope :signage_received, -> { with_state(:signage_received) }
  scope :no_gps, -> { with_state(:no_gps) }
  scope :extracted_metadata, -> { with_state(:extracted_metadata) }
  scope :signage_reviewable, -> { with_state(:signage_reviewable) }
  scope :blurry, -> { with_state(:blurry) }
  scope :inappropriate, -> { with_state(:inappropriate) }
  scope :ready_to_contact_broker, -> { with_state(:ready_to_contact_broker) }
  scope :broker_contacted, -> { with_state(:broker_contacted) }

  state_machine initial: :signage_received do
    event :no_gps do
      transition  :signage_received => :no_gps
    end
    event :signage_reviewable do
      transition :signage_received => :signage_reviewable
    end
    event :blurry do
      transition :signage_reviewable => :blurry
    end
    event :inappropriate do
      transition :signage_reviewable => :inappropriate
    end
    event :extract_phone do
      transition :signage_reviewable => :ready_to_contact_broker
    end
    event :broker_contacted do
      transition :ready_to_contact_broker => :broker_contacted
    end
  end

  def default_values
    self.submission_method ||= 'email'
    self.submitted_at ||= Time.now
    self.submitter ||= "Cato"
  end

  def self.create_from_postmark(message)
    # ignore messages with no attachments
    if message.attachments.empty?
      logger.info "message #{message.message_id}: no attachments!; skipping."
      return
    end

    message.attachments.each {|attachment, i|
      logger.info "message #{message.message_id}: reading attachment #{i} ('#{attachment.file_name}') of type #{attachment.content_type}"
      begin
        signage = SignageUploader.new
        signage.cache!(attachment.read)
      rescue CarrierWave::IntegrityError => e
        # puts there was a problem storing attachments
        logger.error "message #{message.message_id}: problem storing attachment #{i} ('#{attachment.file_name}') of message #{message.message_id}"
        logger.error [e, *e.backtrace].join("\n")
        return
      end

      n = Nugget.new(
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
        n.signage_reviewable!
      end
    }
  end

end

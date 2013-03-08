class Nugget < ActiveRecord::Base
  mount_uploader :signage, SignageUploader

  reverse_geocoded_by :latitude, :longitude, {address: :signage_address}
  before_save :default_values
  #before_save :process_geodata

  attr_accessible :latitude, :longitude
  attr_accessible :submission_method, :submitted_at, :submitter
  attr_accessible :state
  attr_accessible :nugget_type, :nugget_phone, :approx_address
  attr_accessible :signage
  attr_accessible :signage_address, :signage_city, :signage_state, :signage_county, :signage_neighborhood

  validates_inclusion_of :nugget_type, :in => %w(lease sale), :allow_nil => true
  validates_inclusion_of :submission_method, :in => %w(email sms), :allow_nil => true

  default_scope order(:submitted_at)
  scope :signage_received, -> { with_state(:signage_received) }
  scope :no_gps, -> { with_state(:no_gps) }
  scope :signage_reviewable, -> { with_state(:signage_reviewable) }
  scope :blurry, -> { with_state(:blurry) }
  scope :inappropriate, -> { with_state(:inappropriate) }
  scope :ready_to_contact_broker, -> { with_state(:ready_to_contact_broker) }
  scope :broker_contacted, -> { with_state(:broker_contacted) }
  #
  #scope :signage_reviewable_lock, -> { with_state(:signage_reviewable_lock) }
  #scope :ready_to_contact_broker_lock, -> { with_state(:ready_to_contact_broker_lock) }

  state_machine initial: :signage_received do
    event :no_gps do
      transition  :signage_received => :no_gps
    end
    event :signage_reviewable do
      transition :signage_received => :signage_reviewable
    end
    # event :signage_reviewable_lock do
    #   transition :signage_reviewable => :signage_reviewable_lock
    # end
    # event :signage_reviewable_unlock do
    #   transition :signage_reviewable_lock => :signage_reviewable
    # end
    event :blurry do
      transition :signage_reviewable => :blurry
    end
    event :inappropriate do
      transition :signage_reviewable => :inappropriate
    end
    event :extract_phone do
      transition :signage_reviewable => :ready_to_contact_broker
    end
    # event :ready_to_contact_broker_lock do
    #   transition :ready_to_contact_broker => :ready_to_contact_broker_lock
    # end
    # event :ready_to_contact_broker_unlock do
    #   transition :ready_to_contact_broker_lock => :ready_to_contact_broker
    # end
    event :broker_contacted do
      transition :ready_to_contact_broker => :broker_contacted
    end
  end

  def latlong
    "#{latitude},#{longitude}"
  end

  def default_values
    self.submission_method ||= 'email'
    self.submitted_at ||= Time.now
    self.submitter ||= "Cato"
  end

  def editable?
    self.editable_until.nil? || self.editable_until >= Time.now
  end

  def process_geodata
    #if latitude_changed? or longitude_changed?
    #end
    res = Geocoder.search(latlong)
    if res.present?
      populate_address(res.first)
    end
  end


  protected
  def is_editable
    self.errors[:editable_until] << "this record is locked" unless editable?
  end

  def set_editable_time
    time_to_lock = case self.state_name
      when :signage_reviewable
        time_to_lock = 5.min
      when :ready_to_contact_broker
        time_to_lock = 10.min
      else
        time_to_lock = 1.min
    end

    self.editable_until ||= Time.now + time_to_lock
  end

  private
  def populate_address(geo_addr)
    self.signage_city = geo_addr.city
    self.signage_state = geo_addr.state
    self.signage_county = geo_addr.address_components_of_type('administrative_area_level_2').first['long_name']
    self.signage_neighborhood = geo_addr.address_components_of_type('neighborhood').first['long_name']
    self.signage_address = geo_addr.address
  end
end

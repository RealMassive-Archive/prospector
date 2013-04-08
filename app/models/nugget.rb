# == Schema Information
#
# Table name: nuggets
#
#  id                         :integer          not null, primary key
#  state                      :string(255)
#  latitude                   :decimal(, )
#  longitude                  :decimal(, )
#  submitter                  :string(255)
#  submission_method          :string(255)
#  submitted_at               :datetime         not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  signage                    :string(255)
#  signage_address            :string(255)
#  signage_city               :string(255)
#  signage_state              :string(255)
#  signage_county             :string(255)
#  signage_neighborhood       :string(255)
#  editable_until             :datetime
#  signage_phone              :string(255)
#  signage_listing_type       :string(255)
#  message_id                 :string(255)
#  submitter_notes            :string(255)
#  is_new_multisignage_nugget :boolean
#

class Nugget < ActiveRecord::Base
  has_many :nugget_signages, :dependent => :destroy

  # old
  # mount_uploader :signage, SignageUploader
  # attr_accessible :signage, :is_new_multisignage_nugget

  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
  before_create :default_values
  #before_save :process_geodata

  has_many :nugget_state_transitions

  #might be old in light of multiple signages per nugget
  acts_as_taggable
  #might be old in light of multiple signages per nugget
  acts_as_taggable_on :signage_tags

  attr_accessor :user #note: we're decorating here to make gem 'state_machine-audit_trail' save a user.id kill this line if this gem is removed

  attr_accessible :latitude, :longitude
  attr_accessible :submission_method, :submitted_at, :submitter, :submitter_notes, :message_id
  attr_accessible :state
  attr_accessible :nugget_type, :nugget_phone, :approx_address

  attr_accessible :signage_address, :signage_city, :signage_state, :signage_county, :signage_neighborhood
  attr_accessible :signage_phone, :signage_listing_type

  validates_inclusion_of :signage_listing_type, :in => %w(lease sale), :allow_nil => true
  validates_inclusion_of :submission_method, :in => %w(email sms), :allow_nil => true

  default_scope order('submitted_at ASC')

  scope :signage_read, -> { with_state(:signage_read) }
  scope :no_gps, -> { with_state(:no_gps) }
  scope :signage_reviewed, -> { with_state(:signage_reviewed) }
  scope :signage_rejected, -> { with_state(:signage_rejected) }
  scope :blurry, -> { with_state(:blurry) }
  scope :inappropriate, -> { with_state(:inappropriate) }
  scope :ready_to_contact_broker, -> { with_state(:ready_to_contact_broker) }
  scope :awaiting_broker_response, -> { with_state(:awaiting_broker_response) }
  scope :initial, -> { with_state(:initial)}

  scope :read_signage_jobs, -> { where("editable_until IS NULL OR editable_until < ?", Time.now).with_state(:signage_read) }
  scope :review_signage_jobs, -> { where("editable_until IS NULL OR editable_until < ?", Time.now).with_state(:signage_reviewed) }
  scope :contact_broker_jobs, -> { where("editable_until IS NULL OR editable_until < ?", Time.now).with_state(:ready_to_contact_broker) }

  state_machine initial: :initial do
    store_audit_trail :context_to_log => :state_message # Will grab the results of the state_message method on the model and store it in a field called state_message on the audit trail model
    event :no_gps do
      transition :initial => :no_gps
    end
    event :signage_read do
      transition :initial => :signage_read
    end
    event :signage_review do
      transition :signage_read => :signage_reviewed
    end
    event :blurry do
      transition :signage_reviewed => :blurry
    end
    event :inappropriate do
      transition :signage_reviewed => :inappropriate
    end
    event :signage_reject do
      transition :signage_reviewed => :signage_rejected
    end
    event :signage_approve do
      transition :signage_reviewed => :ready_to_contact_broker
    end
    event :broker_contact do
      transition :ready_to_contact_broker => :awaiting_broker_response
    end

    # convenience:  push any nugget back to  initial state
    event :reset do
      transition :any => :initial
    end
  end

  def state_message
    msg = user.present? ? "#{user.name} (#{user.id})" : "SYSTEM"
    "by: #{msg}"
  end

  def latlong
    "#{latitude},#{longitude}"
  end

  def address
    self.signage_address
  end

  def default_values
    self.submitted_at ||= Time.now
    self.submitter ||= "SYSTEM"
    self.is_new_multisignage_nugget ||= true
  end

  def editable?
    self.editable_until.nil? || self.editable_until <= Time.now
  end

  def process_geodata
    #if latitude_changed? or longitude_changed?
    #end
    res = Geocoder.search(latlong)
    if res.present?
      populate_address(res.first)
    end
  end

  def is_editable
    self.errors[:editable_until] << "this record is locked" unless editable?
  end

  def set_editable_time
    time_to_lock = case self.state_name
      when :signage_read
        time_to_lock = 1.minutes
      when :signage_reviewed
        time_to_lock = 3.minutes
      when :ready_to_contact_broker
        time_to_lock = 10.minutes
      else
        time_to_lock = 1.minutes
    end

    self.editable_until ||= Time.now + time_to_lock
  end

  def unset_editable_time
    self.editable_until = nil
  end

  def populate_address(geo_addr)
    self.signage_city = geo_addr.city
    self.signage_state = geo_addr.state
    if geo_addr.address_components_of_type('administrative_area_level_2').present?
      self.signage_county = geo_addr.address_components_of_type('administrative_area_level_2').first['long_name']
    end
    if geo_addr.address_components_of_type('neighborhood').present?
      self.signage_neighborhood = geo_addr.address_components_of_type('neighborhood').first['long_name']
    end
    self.signage_address = geo_addr.address
  end
end

class Nugget < ActiveRecord::Base
  attr_accessible :latitude, :longitude
  attr_accessible :submission_method, :submission_on, :submitter
  attr_accessible :state
  attr_accessible :nugget_type, :nugget_phone, :approx_address

  validates_inclusion_of :nugget_type, :in => %w(lease sale), :allow_nil => true
  validates_inclusion_of :submission_method, :in => %w(email sms), :allow_nil => true

  before_save :default_values

  default_scope order(:submission_on)
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
    event :extract_metadata do
      transition :signage_received => :extracted_metadata
    end
    event :saved_to_cdn do
      transition :extracted_metadata => :signage_reviewable
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
    self.submission_on ||= Time.now
    self.submitter ||= "Cato"
  end

end

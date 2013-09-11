class Listing < ActiveRecord::Base
  attr_accessible :metro_listed_in,:building_name,:unit_number,:street_address,:street_address2,:street_address3,:city,:state_province,
                  :country,:latitude,:longitude,:listing_type,:neighborhood,:zip_postal_code,:space,:space_units,:description,:title,:lease_rate,:lease_rate_units,
                  :broker_first_name,:broker_last_name,:broker_email,:broker_phone,:broker2_first_name,:broker2_last_name,:broker2_email,:broker2_phone,
                  :brokerage_name,:landlord_name,:state,:listing_nugget_id

  validates :street_address, presence: true
  validates :city, presence: true
  validates :state_province, presence: true
  belongs_to :listing_nugget
  has_many :listing_attachments,:dependent => :destroy
  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude

  state_machine :initial => :open do

  end


end

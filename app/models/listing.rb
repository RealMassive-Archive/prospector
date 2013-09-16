# == Schema Information
#
# Table name: listings
#
#  id                 :integer          not null, primary key
#  listing_type       :string(255)
#  metro_listed_in    :string(255)
#  building_name      :string(255)
#  unit_number        :string(255)
#  street_address     :string(255)
#  street_address2    :string(255)
#  street_address3    :string(255)
#  city               :string(255)
#  state_province     :string(255)
#  country            :string(255)
#  latitude           :decimal(, )
#  longitude          :decimal(, )
#  neighborhood       :string(255)
#  zip_postal_code    :string(255)
#  space              :decimal(, )
#  space_units        :string(255)
#  description        :string(255)
#  title              :string(255)
#  lease_rate         :decimal(, )
#  lease_rate_units   :string(255)
#  broker_first_name  :string(255)
#  broker_last_name   :string(255)
#  broker_email       :string(255)
#  broker_phone       :string(255)
#  broker2_first_name :string(255)
#  broker2_last_name  :string(255)
#  broker2_email      :string(255)
#  broker2_phone      :string(255)
#  brokerage_name     :string(255)
#  landlord_name      :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  state              :string(255)
#  listing_nugget_id  :integer
#

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

  scope :open, -> { with_state(:open) }
  scope :pushed_live, -> { with_state(:pushed_live) }

  state_machine :initial => :open do
    event :push_live do
      transition :open => :pushed_live
    end
  end


end

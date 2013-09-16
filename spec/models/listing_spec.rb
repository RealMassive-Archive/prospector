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

require 'spec_helper'

describe Listing do
  pending "add some examples to (or delete) #{__FILE__}"
end

class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.string  :listing_type
      t.string  :metro_listed_in
      t.string  :building_name
      t.string  :unit_number
      t.string  :street_address
      t.string  :street_address2
      t.string  :street_address3
      t.string  :city
      t.string  :state_province
      t.string  :country
      t.decimal :latitude
      t.decimal :longitude
      t.string  :neighborhood
      t.string  :zip_postal_code
      t.string  :unit_number
      t.decimal :space
      t.string  :space_units
      t.string  :description
      t.string  :title
      t.decimal :lease_rate
      t.string  :lease_rate_units

      t.string  :broker_first_name
      t.string  :broker_last_name
      t.string  :broker_email
      t.string  :broker_phone
      t.string  :broker2_first_name
      t.string  :broker2_last_name
      t.string  :broker2_email
      t.string  :broker2_phone

      t.string  :brokerage_name
      t.string  :landlord_name

      t.timestamps
    end
  end
end

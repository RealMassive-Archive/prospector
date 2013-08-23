class Listing < ActiveRecord::Base
  # attr_accessible :title, :body


  geocoded_by :address
  reverse_geocoded_by :latitude, :longitude
end

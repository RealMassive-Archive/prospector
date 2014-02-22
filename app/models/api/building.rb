#
# building.rb
#
# A basic wrapper class to interface with buildings according to
# the way that buildings have properties in the RealMassive/Electrick-co
# readme located at https://github.com/electrik-co/realmassive/wiki/Building-API
#
# This model is NOT data-store backed in any way. We'll save the request and
# api response in a table at a later date.
#

class Building
  attr_accessor :name
  attr_accessor :type
  attr_accessor :subtype
  attr_accessor :size
  attr_accessor :size_units
  attr_accessor :lot_size
  attr_accessor :lot_size_units
  attr_accessor :building_class
  attr_accessor :year_built
  attr_accessor :highlights
  attr_accessor :address

  attr_reader   :key
  attr_reader   :manager
  attr_reader   :created_by
  attr_reader   :attachments

  def initialize(opts={})
    # Step 1: Find and set key, manager, created_by and attachments.
    # Nil objects are entirely acceptable here if not found in opts{}.
    @key = "TODO"
    @manager = "TODO"
    @created_by = "TODO"
    @attachments = "TODO"

    # Step 2: Loop through opts{} and see if we have a method that
    # responds to that particular parameter, and if so, set it to the value.
    # TODO
binding.pry
  end
end
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
  end

  def self.create(opts={}.with_indifferent_access)
    # Start by checking for all required options to create a new Building object.
    unless opts[:name] && opts[:type] && opts[:subtype] && opts[:size] && opts[:size_units] && opts[:lot_size] && opts[:lot_size_units] && opts[:building_class] && opts[:year_built] && opts[:highlights] && opts[:address]
      raise ArgumentError, "You must supply all editable properties as described at https://github.com/electrik-co/realmassive/wiki/Building-API."
    end

    # Check to be sure address contains what we need
    unless opts[:address][:street] && opts[:address][:city] && opts[:address][:state] && opts[:address][:zipcode]
      raise ArgumentError, "You did not supply street, city, state and zipcode in your address hash."
    end

    # Make sure state is exactly a two-letter abbreviation
    unless opts[:address][:state].length == 2
      raise ArgumentError, "State must be a 2-letter abbreviation."
    end



    # Shove it up there.
  end

  #
  # Building.find(address: ... city: ... state: ... zipcode: ...)
  # Utilizes the Electrick-co API to fetch all buildings by its search
  # functionality and returns an array of hashes with indifferent access.
  #
  def self.find(address, city, state, zipcode)
    # Error checking - make sure we have what we need per the Electrick-co API
    # https://github.com/electrik-co/realmassive/wiki/Building-API
    if address.blank? || city.blank? || state.blank? || state.length != 2 || zipcode.blank?
      raise ArgumentError, "You must supply ALL parameters, and state must be a two-letter abbreviation."
    end

    conn = Excon.new((ENV['ELECTRIC_API_ENDPOINT'] || 'https://realmassive-staging.appspot.com') + "/api/v1/buildings?address")
    response = conn.get(query: { street: address, city: city, state: state, zipcode: zipcode.to_s, limit: 3 })
    new_arr = []
    parsed = ::Yajl::Parser.new.parse(response.body)
    if parsed["results"]
      parsed["results"].each do |x|
        new_arr << x.with_indifferent_access
      end
      return new_arr
    else
      return [] # empty array if there aren't any buildings found
    end


  end

end
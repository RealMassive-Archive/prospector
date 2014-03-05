#
# space.rb
#
# A basic class to create and retrieve spaces in the Electrick API based on
# documentation at https://github.com/electrik-co/realmassive/wiki/Space-API.
#

class Space
  #
  # Building.create("abc123", {space_type: ..., unit_number: ...})
  #
  # Creates a building object returning the response parsed into
  # a hash (instead of raw JSON).
  # Options:
  #   space_type
  #   description
  #   unit_number
  #   rate
  #   rate_units
  #   space_available
  #   space_available_units
  #   floor_number
  #
  def self.create(building_key, options={}.with_indifferent_access)
    all_options = (options.reject {|k,v| k == :building_key }).merge({:building_key => building_key})
    response = ApiWrapper.post("/api/v1/spaces", all_options)
    if response.code == 200
      return Yajl::Parser.parse(response.body)
    end
    return nil # if it failed, throw nil
  end

  def self.fetch(id)
    response = ApiWrapper.get("/api/v1/spaces/#{id}", '')
    if response.code == 200
      return Yajl::Parser.parse(response.body)
    end
    return nil # if it didn't succeed, throw a nil object
  end

end

class Space < ActiveRecord::Base
  #
  # space.rb
  #
  # A basic class to create and retrieve spaces in the Electrick API based on
  # documentation at https://github.com/electrik-co/realmassive/wiki/Space-API.

  #
  # Space.allowed_queries
  # Provides an array of symbols specifying the allowed methods that will be
  # later used by Object#send. This is to prevent abuse of the send method,
  # especially when user input is at least somewhat utilized. (security)
  def self.allowed_queries
    [:fetch, :api_create]
  end

  #
  # Space.api_create({building_key: 'abc123...', space_type: 'office', ...})
  #
  # Creates a building object returning the response object from ApiWrapper.
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
  def self.api_create(options={})
    # Make the options with indifferent access
    options = options.with_indifferent_access # From ActiveSupport, allows
                                              # access to options[:foo] instead
                                              # of options['foo']

    # Specify which options are allowed. Nothing other than this gets pushed
    # to the API for any reason whatsoever.
    allowed_options = [:space_type, :description, :unit_number, :rate,
                       :rate_units, :space_available, :space_available_units,
                       :floor_number, :building_key]

    options.delete_if do |k,v|
      !allowed_options.include?(k.to_sym)
    end
    return ApiWrapper.post("/api/v1/spaces", options)
  end

  #
  # Space.fetch("abc123")
  #
  # Fetch a space given its UUID from the Electrick-co API.
  #   id - a UUID string from the API.
  #
  def self.fetch(id)
    response = ApiWrapper.get("/api/v1/spaces/#{id}", '')
    if response.code == 200
      return Yajl::Parser.parse(response.body)
    end
    return nil # if it didn't succeed, throw a nil object
  end

  #
  # Space.exists?(building_key, unit_number, floor_number=nil)
  #
  # Reference the spaces in a given building, looking for at least the
  # specific unit_number in that building. If found, it will examine
  # the floor number as will, if passed in. The idea is that there could
  # be more than one suite "A", just on different floors, but only
  # one "Suite 202" in the entire building on the same floor.
  #
  # Options:
  #   building_key: the UUID of the building in question. Use Building.search
  #                 to find it.
  #   unit_number:  the specific unit number you're checking to see if exists.
  #   floor_number: (default: nil) Only supply if you want to check for the same
  #                 space on the same floor. Will be ignored if not present.
  #
  # Returns:
  #   true:         space exists already
  #   false:        space does not yet exist, or no duplicate found

  def self.exists?(building_key, unit_number, floor_number = nil)
    bldg = Building.fetch(building_key)
    unless bldg['key'] && bldg['key'].length > 0 # we have an API-supplied key
      return false # No building? Then the space can't possibly exist.
    end

    # Fetch the spaces in this building.
    spaces = Yajl::Parser.parse(ApiWrapper.get(
      "/api/v1/buildings/#{building_key}/spaces",
      { admin: true }
    ).body)

    return true if spaces.any? do |x|
      x['building'] &&
      x['building']['building'] &&
      x['building']['building'].to_s == building_key.to_s &&
      x['unit_number'].to_s == unit_number.to_s &&
      (
      if floor_number
        x['floor_number'].to_s == floor_number.to_s
       else
        true
       end
      )
    end

    return false # Didn't hit the return true above so the space must not exist
  end

end

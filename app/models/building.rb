class Building < ActiveRecord::Base

  #
  # building.rb
  #
  # An ActiveRecord class to interface with buildings according to
  # the way that buildings have properties in the RealMassive/Electrick-co
  # readme located at
  # https://github.com/electrik-co/realmassive/wiki/Building-API

  # NOTE: This "DSL" needs to conform to a standard that has all API-related
  # methods accept a hash of options. This is to facilitate some very basic
  # metaprogramming throughout the system that allows for dynamic "queries"
  # of the model based on information gathered from the database at runtime.

  #
  # Building.allowed_queries
  # Provides an array of symbols specifying the allowed methods that will be
  # later used by Object#send. This is to prevent abuse of the send method,
  # especially when user input is at least somewhat utilized. (security)
  def self.allowed_queries
    [:fetch, :api_create, :search]
  end

  #
  # fetch(key)
  #   Fetches a building from the API using the key passed in.
  #   Parameters:
  #     key: {uuid: "abc123..."} the UUID key of the building. This is
  #                         authoratatively supplied by the API.
  #
  def self.fetch(key = {})
    key = key.with_indifferent_access # make it easier
    return ApiWrapper.get("/api/v1/buildings/#{key[:uuid]}", '')
  end

  #
  # Building.api_create(addr) # addr = {street: ..., city: ..., ...}
  # Creates a building. Returns the response object.
  # Parameters:
  #   address: Hash containing street, city, state, zipcode keys
  #
  def self.api_create(address={})
    # Error checking - make sure we have what we need per the Electrick-co API
    # https://github.com/electrik-co/realmassive/wiki/Building-API
    if address.blank?
      raise ArgumentError, "The address hash is blank."
    end

    # Grab the "name" parameter off the address hash
    title = (address['title'] || address['name'])
    address = address.reject{|k| [:name, :title].include?(k) }
      .with_indifferent_access

    # Address must have ALL of the following keys
    [:street, :city, :state, :zipcode].each do |k|
      unless address[k] || address[k].blank?
        raise ArgumentError, "address[:#{k}] is blank and shouldn't be"
      end
    end

    if address[:state].length != 2
      raise ArgumentError, "address[:state] must be an exact two-letter state abbreviation."
    end

    # Finally, send the payload to the API and return a response.
    return ApiWrapper.post('/api/v1/buildings', {title: title, address: address})
  end

  #
  # Building.search(addr) # addr = { street: ... city: ... ... }
  # Utilizes the Electrick-co API to fetch all buildings by its search
  # functionality and returns an array of hashes with indifferent access.
  #
  def self.search(address={})
    # Error checking - make sure we have what we need per the Electrick-co API
    # https://github.com/electrik-co/realmassive/wiki/Building-API
    if address.blank?
      raise ArgumentError, "The address hash is blank."
    end

    # Make the address more easily accessible
    address = address.with_indifferent_access

    # Address must have ALL of the following keys
    [:street, :city, :state, :zipcode].each do |k|
      unless address[k] || address[k].blank?
        raise ArgumentError, "address[:#{k}] is blank and shouldn't be."
      end
    end

    if address[:state].length != 2
      raise ArgumentError, "address[:state] must be an exact two-letter state abbreviation."
    end

    # Perform GET request to retrieve results
    return ApiWrapper.get('/api/v1/buildings', {address: address, limit: 3})
      # RE: limit: 3 - if there's only one in the entire set it's an exact
      # match and that's the one you want to add to. If not, there will be N
      # matches. If it isn't within the first of those three, since they're
      # ordered by geographic proximity, there's no point since it's obviously
      # not in the result set.

    # If you're looking for the actual results, it's in body['results']
    # return Yajl::Parser.parse(results.body)['results']
  end
end

class Building < ActiveRecord::Base

  #
  # building.rb
  #
  # An ActiveRecord class to interface with buildings according to
  # the way that buildings have properties in the RealMassive/Electrick-co
  # readme located at https://github.com/electrik-co/realmassive/wiki/Building-API

  #
  # fetch(key)
  #   Fetches a building from the API using the key passed in.
  #   Parameters:
  #     key: the UUID key of the building. This is authoratatively supplied by
  #          the API.
  #
  def self.fetch(key)
    return Yajl::Parser.parse(ApiWrapper.get("/api/v1/buildings/#{key}", '').body)
  end

  #
  # Building.api_create(addr) # addr = {street: ..., city: ..., ...}
  # Creates a building. Returns the response object.
  # Parameters:
  #   address: Hash containing street, city, state, zipcode keys
  #
  def self.api_create(address={}.with_indifferent_access)
    # Error checking - make sure we have what we need per the Electrick-co API
    # https://github.com/electrik-co/realmassive/wiki/Building-API
    if address.blank?
      raise ArgumentError, "The address hash is blank."
    end

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
    return Yajl::Parser.parse(ApiWrapper.post('/api/v1/buildings', {address: address}).body)
  end

  #
  # Building.search(addr) # addr = { street: ... city: ... ... }
  # Utilizes the Electrick-co API to fetch all buildings by its search
  # functionality and returns an array of hashes with indifferent access.
  #
  def self.search(address={}.with_indifferent_access)
    # Error checking - make sure we have what we need per the Electrick-co API
    # https://github.com/electrik-co/realmassive/wiki/Building-API
    if address.blank?
      raise ArgumentError, "The address hash is blank."
    end

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
    results = ApiWrapper.get('/api/v1/buildings', {address: address, limit: 3})
      # RE: limit: 3 - if there's only one in the entire set it's an exact
      # match and that's the one you want to add to. If not, there will be N
      # matches. If it isn't within the first of those three, since they're
      # ordered by geographic proximity, there's no point since it's obviously
      # not in the result set.

    # Return the actual buildings that the API gave us
    return Yajl::Parser.parse(results.body)['results']
  end
end

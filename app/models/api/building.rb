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
  #
  # create({street: "...", city: "..." ...})
  # Creates a building. Returns the response object.
  # Parameters:
  #   address: Hash containing street, city, state, zipcode keys
  #
  def self.create(address={}.with_indifferent_access)
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
  # Building.find(address: ... city: ... state: ... zipcode: ...)
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
        raise ArgumentError, "address[:#{k}] is blank and shouldn't be"
      end
    end

    if address[:state].length != 2
      raise ArgumentError, "address[:state] must be an exact two-letter state abbreviation."
    end

    # Perform GET request to retrieve results
    results = ApiWrapper.get('/api/v1/buildings', {address: address, limit: 3})

    # Return the actual buildings that the API gave us
    return Yajl::Parser.parse(results.body)['results']

  end
end

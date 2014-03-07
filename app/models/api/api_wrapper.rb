#
# Wrapper class that uses Typhoeus (https://github.com/typhoeus/typhoeus)
# to perform API requests against the Electrick API.
#
class ApiWrapper

  #
  # ApiWrapper.get('/api/v1/buildings', {address: {...}} )
  #   path: the path to run the GET against
  #   params: the request params to throw. Should be a hash when passed in.
  #
  def self.get(path, params = nil)
    response = Typhoeus::Request.new(
      ENV['ELECTRICK_API_ENDPOINT'] + path,
      method: :get,
      params: params,
      userpwd: [ENV['ELECTRICK_API_USERNAME'],ENV['ELECTRICK_API_PASSWORD']].join(':')
    )
    return response.run
  end

  #
  # ApiWrapper.post('/api/v1/buildings', {address: {...}})
  #   path: The path you're going to POST to
  #   body: POST request body
  #
  def self.post(path, body)
    response = Typhoeus::Request.new(
      ENV['ELECTRICK_API_ENDPOINT'] + path,
      method: :post,
      body:   Yajl::Encoder.encode(body), # params are automaticaly encoded by Typhoeus, but not body
      userpwd: [ENV['ELECTRICK_API_USERNAME'],ENV['ELECTRICK_API_PASSWORD']].join(':')
    )
    return response.run
  end
end

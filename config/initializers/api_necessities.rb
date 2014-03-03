# Load all the API-specific models
Dir["#{Rails.root}/app/models/api/*.rb"].each { |f| require f }

# Get or set environment variables needed for communication with the API.
# The defaults supplied herein are for basic auth against the Electrick-co
# API and are only for staging. Production values will be specified by
# environment variables.
defaults = {
  electrick_api_endpoint: 'https://realmassive-staging.appspot.com',
  electrick_api_username: 'prospector',
  electrick_api_password: '12345'
}

defaults.each do |env_var, val|
  unless ENV[env_var.to_s.upcase]
    ENV[env_var.to_s.upcase] = defaults[env_var]
  end
end

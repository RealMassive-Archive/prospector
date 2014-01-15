source 'https://rubygems.org'
ruby '2.0.0'

gem 'rails', '~> 3.2.14'
gem 'pg'
gem 'carrierwave'
gem "mini_magick"
gem "fog", "~> 1.3.1"
gem 'geocoder'
gem 'state_machine'
gem 'state_machine-audit_trail'
gem 'acts-as-taggable-on'
gem 'resque', "~> 1.25.1" # redis is a dependency

# send emails
gem 'postmark-rails'

# receive emails
gem 'postmark-mitt'

# read metadata from photos (use for getting Lat/Log data)
# Note: mini_magick supposedly does this as well,
# so exifr may be redundant (JCQ, March 2013)
gem 'exifr', :git => 'git://github.com/picuous/exifr.git'

gem 'will_paginate'
gem 'will_paginate-bootstrap', '~> 0.2.5' # app is using old bootstrap, need old gem

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "bootstrap-sass", "~> 2.3.0.0"
  gem 'bootstrap-x-editable-rails'
end

gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'annotate'
gem "devise", ">= 2.2.3"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "figaro", ">= 0.5.3"
gem 'faker'
gem 'httparty'
gem 'jquery-ui-rails'

# This will allow future switches
# between major application servers
# with minimal effort.
group :applicaiton_servers do
  gem 'puma' # concurrency
  gem 'thin' # evented
  gem 'unicorn' # just plain awesome
end

group :development, :test do
  gem "rspec-rails", ">= 2.12.2"
  gem "database_cleaner", ">= 0.9.1"
  gem "email_spec", ">= 1.4.0"
  gem "cucumber-rails", ">= 1.3.0", require: false
  gem "launchy", ">= 2.2.0"
  gem "capybara", ">= 2.0.2"
  gem "factory_girl_rails", ">= 4.2.0"
  gem "quiet_assets", ">= 1.0.1"
  gem "better_errors", ">= 0.6.0"
  gem "binding_of_caller", ">= 0.7.1", :platforms => [:mri_19, :rbx]
  gem 'html2haml'

  # with this gem, call "rake haml:convert_erbs" or
  # "rake haml:replace_erbs" to batch-convert any erb
  # to haml (will not overwrite existing haml files
  gem 'erb2haml'

  gem 'pry'
  gem 'pry-rails'
  gem 'rb-readline', '~> 0.5.0', :require=>false
end

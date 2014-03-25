source 'https://rubygems.org'
ruby '2.1.1'

gem 'rails', '~> 3.2.17'
gem 'pg'
gem 'carrierwave'
gem "mini_magick"
gem "fog", "~> 1.20.0"
gem 'geocoder'
gem 'state_machine'
gem 'state_machine-audit_trail'
gem 'acts-as-taggable-on'
gem 'resque', "~> 1.25.1" # redis is a dependency
gem "yajl-ruby", "~> 1.2.0", require: 'yajl' # faster json parser
gem 'haml'
gem 'haml-rails'
gem "devise", ">= 2.2.3"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "figaro", ">= 0.5.3"
gem 'faker' # for "fake" broker email addresses
gem 'faraday', "~> 0.9.0"
gem "typhoeus", "~> 0.6.7"
gem 'jquery-ui-rails'
gem 'will_paginate'
gem 'will_paginate-bootstrap', '~> 0.2.5' # app is using old bootstrap, need old gem
gem 'thin' # evented

# send emails
gem 'postmark-rails'

# receive emails
gem 'postmark-mitt'

# read metadata from photos (use for getting Lat/Log data)
# Note: mini_magick supposedly does this as well,
# so exifr may be redundant (JCQ, March 2013)
gem 'exifr', :git => 'git://github.com/picuous/exifr.git'

group :assets do
  gem 'jquery-rails', '~> 3.1.0'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem "bootstrap-sass", "~> 2.3.0.0"
  gem 'bootstrap-x-editable-rails'
end

group :development, :test do
  gem "better_errors", ">= 0.6.0"
  gem "binding_of_caller"
  gem 'annotate'
  gem 'pry-rails'
end

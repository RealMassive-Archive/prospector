source 'https://rubygems.org'
gem 'rails', '3.2.12'
gem 'pg'
gem 'thin'

gem 'carrierwave'
gem "fog", "~> 1.3.1"
gem 'geocoder'
gem 'state_machine'
gem 'state_machine-audit_trail'
gem 'acts-as-taggable-on'

# receive emails
gem 'postmark-mitt'
# read metadata from photos (use for getting Lat/Log data)
gem 'exifr', :git => 'git://github.com/picuous/exifr.git'


group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end
gem 'jquery-rails'
gem 'haml'
gem 'haml-rails'
gem 'annotate'

gem "rspec-rails", ">= 2.12.2", :group => [:development, :test]
gem "database_cleaner", ">= 0.9.1", :group => :test
gem "email_spec", ">= 1.4.0", :group => :test
gem "cucumber-rails", ">= 1.3.0", :group => :test, :require => false
gem "launchy", ">= 2.2.0", :group => :test
gem "capybara", ">= 2.0.2", :group => :test
gem "factory_girl_rails", ">= 4.2.0", :group => [:development, :test]
gem "bootstrap-sass", ">= 2.3.0.0"
gem "devise", ">= 2.2.3"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "quiet_assets", ">= 1.0.1", :group => :development
gem "figaro", ">= 0.5.3"
gem "better_errors", ">= 0.6.0", :group => :development
gem "binding_of_caller", ">= 0.7.1", :group => :development, :platforms => [:mri_19, :rbx]

group :development do
  gem 'html2haml'
  gem 'erb2haml'   # with this gem, call "rake haml:convert_erbs" or "rake haml:replace_erbs" to batch-convert any erb to haml (will not overwrite existing haml files

  gem 'pry'
  gem 'pry-rails'
end

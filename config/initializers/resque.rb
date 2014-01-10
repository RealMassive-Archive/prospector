#
# resque.rb
#
# 10 January 2014 - J. Austin Hughey <jaustinhughey@me.com>
#
# Creates basic settings for utilizing Redis/Resque in both dev and prod.
# In development, this app will expect that you have redis installed
# and working on localhost:6379. In production, it will look for the
# environment variable "REDISCLOUD_URL".
#

require 'redis'
require 'resque'
require 'resque/server'
require 'uri'

if ["staging", "production"].include?(Rails.env)
  uri = URI.parse(ENV["REDISCLOUD_URL"])
else
  uri = URI.parse("redis://localhost:6379")
end

Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

# Force logs to actually get flushed
Resque.after_fork = Proc.new do
  # Re-connect to ActiveRecord
  ActiveRecord::Base.establish_connection
end